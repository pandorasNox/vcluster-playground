#!/bin/bash

set -eu
set -o pipefail
# set -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CLUSTER_CONFIG_YAML_PATH="${SCRIPT_DIR}/kind_cluster.yml"
CREATE_INGRESS_CONTROLLER="${SCRIPT_DIR}ingress_controller_deployment.sh"

KIND_CLUSTER_NAME=kind-vcluster-playground

function func_create_cluster(){
    cat ${CLUSTER_CONFIG_YAML_PATH} | kind create cluster --name ${KIND_CLUSTER_NAME} --config=-

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
    kubectl wait --namespace ingress-nginx \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s
}

function func_check_kind_cluster_exists() {
    local CLUSTER_NAME=${1:?no argumemt passed to ${FUNCNAME[0]}}

    set +e
    kind get clusters 2> /dev/null | grep ${CLUSTER_NAME} > /dev/null
    EXIT_CODE=$?
    set -e

    return ${EXIT_CODE}
}

if func_check_kind_cluster_exists ${KIND_CLUSTER_NAME}; then
    echo -e "there is already a kind cluster present, doing nothing"
    exit 0
fi

echo -e "There is no cluster present, creating a cluster with an ingress"

func_create_cluster
