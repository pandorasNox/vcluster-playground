#!/bin/bash
# note: this script likely runs in a container

set -eu
set -o pipefail
# set -x

VCLUSTER_NAME=vcluster-test

vcluster delete ${VCLUSTER_NAME}
