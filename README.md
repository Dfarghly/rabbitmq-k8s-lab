# RabbitMQ K8s Lab

This repo contains a simple Kubernetes lab that deploys RabbitMQ using Helm on a local `kind` cluster.

## Prerequisites

- Docker
- kubectl
- kind
- Helm

## Quick Start

```bash
# 1. Create local cluster (kind)
./scripts/create-cluster-kind.sh

# 2. Install RabbitMQ into the cluster
./scripts/install-rabbitmq.sh


