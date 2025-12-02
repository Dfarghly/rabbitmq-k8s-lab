🐇 RabbitMQ Kubernetes Lab

A complete Kubernetes lab for deploying, testing, monitoring, and load-testing RabbitMQ using the official RabbitMQ Cluster Operator, Prometheus, Alertmanager, and Grafana.

This lab is designed for:

Learning RabbitMQ internals

Hardening configurations

Load testing queues and vhosts

Verifying HA, federation, shovels

Practicing Prometheus alerting

Testing Kubernetes scheduling, affinity, and failure behaviors

Running on kind, k3d, GKE, EKS, AKS, or any Kubernetes cluster

📦 Prerequisites

Install the following:

kubectl

docker

helm (v3+)

Optional:

jq (for alert testing scripts)

kind (for local Kubernetes)

Prometheus + Grafana (if not using included manifests)

📁 Repository Structure
.
├── rabbitmq-operator/
│   ├── README.md
│   ├── rabbitmq-operator.yaml
│   └── values-rabbitmq-operator.yaml
├── rabbitmq-cluster/
│   ├── rabbitmq-cluster-example.yaml
│   ├── rabbitmq-users.yaml
│   ├── rabbitmq-vhosts.yaml
│   └── policies/
│       ├── ha-policy.yaml
│       ├── federation.yaml
│       └── shovel.yaml
├── monitoring/
│   ├── prometheus-config-rabbitmq.yaml
│   ├── alertmanager-config.yaml
│   ├── grafana-dashboard-rabbitmq.json
│   └── scripts/
│       └── rabbitmq-alerts-smoke-test.sh
└── scripts/
    ├── create-cluster-kind.sh
    ├── install-rabbitmq-operator.sh
    ├── install-rabbitmq-cluster.sh
    └── perftest/
        ├── README.md
        ├── perf-test-run.sh
        ├── perf-test-stop.sh
        └── k8s-perftest-job.yaml

🚀 Quick Start — Full RabbitMQ Deployment

Follow these steps for a complete working RabbitMQ environment.

1️⃣ Create a Local Kubernetes Cluster (kind)
./scripts/create-cluster-kind.sh


Creates a multi-node Kubernetes cluster suitable for RabbitMQ HA testing.

2️⃣ Install the RabbitMQ Cluster Operator
helm upgrade --install rabbitmq-operator \
  bitnami/rabbitmq-cluster-operator \
  --namespace rabbitmq-system \
  --create-namespace \
  -f rabbitmq-operator/values-rabbitmq-operator.yaml


This installs:

CRDs

Operator controllers

Webhooks

RBAC

Metrics endpoints

3️⃣ Deploy the RabbitMQ Cluster
kubectl apply -f rabbitmq-cluster/rabbitmq-cluster-example.yaml


This creates a 3-node RabbitMQ cluster with:

Prometheus metrics enabled

Persistent storage

Anti-affinity for HA

Node pool scheduling

Memory/disk watermark tuning

Service annotations for Prometheus scraping

4️⃣ Create RabbitMQ Users, Permissions, and VHosts

Install all users:

kubectl apply -f rabbitmq-cluster/rabbitmq-users.yaml


Install all vhosts:

kubectl apply -f rabbitmq-cluster/rabbitmq-vhosts.yaml


This includes:

lpadmin — admin account

monitoring — Prometheus metrics account

Template for app integrations

Example app vhosts such as app1, crm-events, etc.

5️⃣ Optional Policies (HA, Federation, Shovels)
Enable HA Mirroring
kubectl apply -f rabbitmq-cluster/policies/ha-policy.yaml

Enable Federation
kubectl apply -f rabbitmq-cluster/policies/federation.yaml

Enable Shovel
kubectl apply -f rabbitmq-cluster/policies/shovel.yaml

📊 Monitoring & Alerting

The monitoring stack is in:

monitoring/


Apply Prometheus configuration:

kubectl apply -f monitoring/prometheus-config-rabbitmq.yaml


Apply Alertmanager configuration:

kubectl apply -f monitoring/alertmanager-config.yaml


Prometheus configuration includes:

RabbitMQ metrics

Kubernetes pod & service discovery

Recording rules

RabbitMQ alert rules

queue size

memory alarms

partitions

CPU

exporter health

Alertmanager configuration includes:

Slack placeholders

Paging routes

Team routing

Test routes

Templates

🧪 Smoke-Test RabbitMQ Alerts

Verify Prometheus is evaluating rules:

./monitoring/scripts/rabbitmq-alerts-smoke-test.sh http://localhost:9090


This checks:

Alert rules loaded

Any alerts firing

Missing metrics

Exporter failures

🔥 Load Testing (PerfTest)

Located under:

scripts/perftest/


Run from your laptop:

./scripts/perftest/perf-test-run.sh


Stop load:

./scripts/perftest/perf-test-stop.sh


Run inside Kubernetes:

kubectl apply -f scripts/perftest/k8s-perftest-job.yaml

📈 Grafana Dashboard (RabbitMQ)

Import the dashboard:

monitoring/grafana-dashboard-rabbitmq.json


Dashboard includes:

Publish rates

Ready vs unacked messages

Queue growth

Per-vhost utilization

Node CPU / RAM

Disk IO

Largest queues

Consumer utilization

Network throughput

🧹 Cleanup
kind delete cluster --name rabbitmq-lab

✅ Summary

This RabbitMQ Lab provides:

✔ RabbitMQ Cluster Operator
✔ Highly Available RabbitMQ Cluster
✔ Users, vhosts, permissions
✔ HA / Federation / Shovel policies
✔ Prometheus + Alertmanager
✔ RabbitMQ alert rules
✔ Grafana dashboard
✔ PerfTest load generator
✔ Monitoring validation scripts
✔ Local & cloud-ready setup

Perfect for:

RabbitMQ learning

Load testing

Monitoring & alert creation

Kubernetes operator practice

HA & resilience experiments