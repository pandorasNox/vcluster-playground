#!/bin/bash

set -eu
set -o pipefail
# set -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

NAMESPACE=lab-vcluster
VCLUSTER_NAME=vcluster-test

function func_create_vcluster() {
    vcluster --namespace ${NAMESPACE} create --connect=false --extra-values ${SCRIPT_DIR}/values.yaml ${VCLUSTER_NAME}
}

func_create_vcluster
