#!/usr/bin/env bash
set -e

# ------------------------------------------------------------
# perf-test-stop.sh
# ------------------------------------------------------------
# Stops ALL PerfTest docker containers.
# ------------------------------------------------------------

echo "Stopping perf-test containers..."
docker ps | grep perf-test | awk '{print $1}' | xargs -r docker stop
echo "Done."
