
---

# ▶️ `scripts/perftest/perf-test-run.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# perf-test-run.sh
# ------------------------------------------------------------
# Runs RabbitMQ PerfTest locally against the cluster.
#
# Adjust QUEUE / RATE / SIZE as needed.
# ------------------------------------------------------------

BROKER_URL="${BROKER_URL:-amqp://lpadmin:password@localhost:5672/%2f}"

QUEUE="load-test"
RATE="2000"
SIZE="1024"
PRODUCERS="4"
CONSUMERS="4"

echo "Running PerfTest against $BROKER_URL ..."
echo "Queue: $QUEUE | Rate: $RATE msg/s | Size: $SIZE bytes"

docker run --rm pivotalrabbitmq/perf-test:latest \
  --uri "$BROKER_URL" \
  --queue "$QUEUE" \
  --rate "$RATE" \
  --size "$SIZE" \
  --producers "$PRODUCERS" \
  --consumers "$CONSUMERS"
