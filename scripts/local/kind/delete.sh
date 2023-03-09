#!/bin/bash

set -eu
set -o pipefail
# set -x

KIND_CLUSTER_NAME=kind-vcluster-playground

kind delete cluster --name ${KIND_CLUSTER_NAME}
