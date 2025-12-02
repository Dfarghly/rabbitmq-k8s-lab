#!/usr/bin/env bash
#
# ------------------------------------------------------------
# rabbitmq-alerts-smoke-test.sh
# ------------------------------------------------------------
# Small helper script to:
#   1) Confirm that RabbitMQ alert rules are loaded in Prometheus
#   2) Show currently firing RabbitMQ-related alerts
#
# Works with the RabbitMQ-only Prometheus ConfigMap:
#   prometheus-config-rabbitmq.yaml
#
# ------------------------------------------------------------
# 📌 USAGE
# ------------------------------------------------------------
#
# 1) Port-forward Prometheus (example):
#      kubectl -n monitoring port-forward svc/prometheus 9090:9090
#
# 2) Run this script in another terminal:
#      ./scripts/monitoring/rabbitmq-alerts-smoke-test.sh http://localhost:9090
#
#    If you omit the URL, it defaults to:
#      http://localhost:9090
#
# 3) (Optional) Run your perf-test load to actually trigger alerts:
#      ./scripts/perftest/perf-test-run.sh
#
# ------------------------------------------------------------
# Requirements:
#   - bash
#   - curl
#   - jq  (for JSON parsing)
# ------------------------------------------------------------

set -euo pipefail

PROM_URL="${1:-http://localhost:9090}"

echo "🔍 Using Prometheus at: ${PROM_URL}"
echo

check_dependencies() {
  for bin in curl jq; do
    if ! command -v "$bin" >/dev/null 2>&1; then
      echo "❌ Missing dependency: $bin"
      echo "   Please install $bin and re-run this script."
      exit 1
    fi
  done
}

# ------------------------------------------------------------
# 1) Show RabbitMQ rule group from /api/v1/rules
# ------------------------------------------------------------
show_rabbitmq_rules() {
  echo "------------------------------------------------------------"
  echo "📜 Checking RabbitMQ alert rules loaded in Prometheus..."
  echo "------------------------------------------------------------"

  # Fetch all rule groups
  if ! json_rules=$(curl -fsSL "${PROM_URL}/api/v1/rules"); then
    echo "❌ Failed to query ${PROM_URL}/api/v1/rules"
    exit 1
  fi

  # Filter for the group named 'rabbitmq'
  echo "${json_rules}" \
    | jq '
        .data.groups[]
        | select(.name == "rabbitmq")
      ' || {
        echo "⚠️ Could not find a rule group named 'rabbitmq'."
        echo "   - Is the ConfigMap mounted correctly?"
        echo "   - Did you reload / restart Prometheus?"
      }

  echo
}

# ------------------------------------------------------------
# 2) Show currently firing RabbitMQ alerts
# ------------------------------------------------------------
show_rabbitmq_alerts() {
  echo "------------------------------------------------------------"
  echo "🚨 Currently firing RabbitMQ alerts (if any)..."
  echo "------------------------------------------------------------"

  if ! json_alerts=$(curl -fsSL "${PROM_URL}/api/v1/alerts"); then
    echo "❌ Failed to query ${PROM_URL}/api/v1/alerts"
    exit 1
  fi

  # Filter to alerts whose name or component label indicates RabbitMQ
  echo "${json_alerts}" \
    | jq '
        .data.alerts
        | map(
            select(
              (.labels.alertname | test("RabbitMQ|HighRabbit|RabbitQueue"; "i"))
              or (.labels.component == "rabbitmq")
            )
          )
      ' \
    | jq 'if length == 0
          then
            "No RabbitMQ alerts are firing right now."
          else
            .
          end'
  echo
}

# ------------------------------------------------------------
# Main
# ------------------------------------------------------------
check_dependencies
show_rabbitmq_rules
show_rabbitmq_alerts

echo "✅ Done."
echo "Tip: Use your perf-test scripts to drive load so the RabbitMQ alerts can fire."
echo "     e.g. ./scripts/perftest/perf-test-run.sh"
