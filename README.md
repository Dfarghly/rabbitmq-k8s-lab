# rabbitmq-k8s-lab
RabbitMQ deployed on Kubernetes (operator + Helm chart)  
A secure default user setup (no anonymous, least-privileged user, etc.)  
Some example queues / exchanges / bindings / policies  
Prometheus alerts for RabbitMQ (queue size, CPU, memory, node down)  
A load generator (like perf-test) so people can actually trigger alerts
Repo_Structure:
rabbitmq-k8s-lab/
   ├─ README.md
   ├─ LICENSE
   ├─ .gitignore
   ├─ k8s/
   │  ├─ namespace-rabbitmq.yaml
   │  ├─ namespace-monitoring.yaml
   │  ├─ rabbitmq-cluster.yaml     # RabbitmqCluster CR / Helm values
   │  ├─ rabbitmq-topology.yaml    # queues, policies, users, permissions
   │  └─ perf-test-deployment.yaml
   ├─ helm-values/
   │  ├─ rabbitmq-values.yaml
   │  └─ kube-prometheus-values.yaml
   ├─ monitoring/
   │  ├─ alerts-rabbitmq.yaml      # PrometheusRule
   │  └─ dashboards/               # optional grafana dashboards
   ├─ scripts/
   │  ├─ create-cluster-kind.sh
   │  ├─ install-rabbitmq.sh
   │  ├─ install-monitoring.sh
   │  └─ run-perf-test.sh
   └─ docs/
      ├─ architecture.md
      ├─ rabbitmq-security.md
      └─ troubleshooting.md

