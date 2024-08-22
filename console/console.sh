#!/usr/bin/env bash

set -euo pipefail

TOKEN_SERVICE_ACCOUNT_DURATION="2h"
TOKEN_SERVICE_ACCOUNT_SA="console"
TOKEN_SERVICE_ACCOUNT_NS="kube-system"

BRIDGE_USER_AUTH="disabled"
export BRIDGE_USER_AUTH

BRIDGE_K8S_MODE="off-cluster"
export BRIDGE_K8S_MODE

# BRIDGE_K8S_AUTH="bearer-token"
# export BRIDGE_K8S_AUTH

BRIDGE_K8S_MODE_OFF_CLUSTER_SKIP_VERIFY_TLS=true

BRIDGE_K8S_MODE_OFF_CLUSTER_ENDPOINT=$(kubectl config view -o json | jq '{myctx: .["current-context"], ctxs: .contexts[], clusters: .clusters[]}' | jq 'select(.myctx == .ctxs.name)' | jq 'select(.ctxs.context.cluster ==  .clusters.name)' | jq '.clusters.cluster.server' -r)
export BRIDGE_K8S_MODE_OFF_CLUSTER_ENDPOINT

BRIDGE_K8S_MODE_OFF_CLUSTER_SKIP_VERIFY_TLS=true
export BRIDGE_K8S_MODE_OFF_CLUSTER_SKIP_VERIFY_TLS

BRIDGE_K8S_AUTH_BEARER_TOKEN=$(kubectl create token $TOKEN_SERVICE_ACCOUNT_SA --duration $TOKEN_SERVICE_ACCOUNT_DURATION -n $TOKEN_SERVICE_ACCOUNT_NS)
export BRIDGE_K8S_AUTH_BEARER_TOKEN

echo "Using $BRIDGE_K8S_MODE_OFF_CLUSTER_ENDPOINT"

CONSOLE_IMAGE=${CONSOLE_IMAGE:="quay.io/openshift/origin-console:4.17.0"}
CONSOLE_PORT=${CONSOLE_PORT:=9000}
CONSOLE_IMAGE_PLATFORM=${CONSOLE_IMAGE_PLATFORM:="linux/amd64"}

echo "API Server: $BRIDGE_K8S_MODE_OFF_CLUSTER_ENDPOINT"
echo "Console Image: $CONSOLE_IMAGE"
echo "Console URL: http://localhost:${CONSOLE_PORT}"
echo "Console Platform: $CONSOLE_IMAGE_PLATFORM"

env | grep BRIDGE

# Prefer podman if installed. Otherwise, fall back to docker.
if [ -x "$(command -v podman)" ]; then
    if [ "$(uname -s)" = "Linux" ]; then
        # Use host networking on Linux since host.containers.internal is unreachable in some environments.
        podman run --pull always --platform $CONSOLE_IMAGE_PLATFORM --rm --network=host --env-file <(set | grep BRIDGE) $CONSOLE_IMAGE
    else
        podman run --pull always --platform $CONSOLE_IMAGE_PLATFORM --rm -p "$CONSOLE_PORT":9000 --env-file <(set | grep BRIDGE) $CONSOLE_IMAGE
    fi
else
    docker run --pull always --platform $CONSOLE_IMAGE_PLATFORM --rm -p "$CONSOLE_PORT":9000 --env-file <(set | grep BRIDGE) $CONSOLE_IMAGE
fi
