# RabbitMQ PerfTest Scripts

This folder contains scripts and Kubernetes manifests used for load-testing
RabbitMQ clusters using the official `rabbitmq-perf-test` tool.

The goal is to generate predictable load on queues so you can test:

- Queue size alerts
- Memory & CPU alerts
- Federated queue throughput
- Shovel performance
- Node stability under load

---

## 📦 Requirements

- A running RabbitMQ cluster (`rabbitmq-lab`)
- `kubectl` installed
- Optional: local Java runtime for running the JAR

---

## 🚀 Local PerfTest Run (Recommended)

Run load from your laptop:

```bash
./scripts/perftest/perf-test-run.sh
./scripts/perftest/perf-test-stop.sh