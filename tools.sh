#!/usr/bin/env bash

set -o errexit
set -o nounset
# set -o xtrace

if set +o | grep -F 'set +o pipefail' > /dev/null; then
  # shellcheck disable=SC3040
  set -o pipefail
fi

if set +o | grep -F 'set +o posix' > /dev/null; then
  # shellcheck disable=SC3040
  set -o posix
fi

# -----------------------------------------------------------------------------

__usage="
Usage: $(basename $0) [OPTIONS]
Options:
  build             ...
  cli               ...
  cluster           ...
"

__usage_cluster="
Usage: cluster [OPTIONS]
Options:
  create            ...
  delete            ...
"

# -----------------------------------------------------------------------------

function func_build() {
  # for debug
  # docker build --progress=plain .

  # docker build .
  docker build -q .
}

function func_cli() {
  docker run -it --rm \
    --network="host" \
    -v "$(pwd):/workdir" \
    -v "${KUBECONFIG_FILE_PATH}:/tmp/kube-config:ro" \
    -w "/workdir" \
    --entrypoint="ash" \
    $(func_build) \
    -ce 'mkdir -p /root/.kube; cp /tmp/kube-config /root/.kube/config; ash'
}

# -----------------------------------------------------------------------------

if [ -z "$*" ]
then
  echo "$__usage"
else
    if [ $1 == "--help" ] || [ $1 == "-h" ]
    then
        echo "$__usage"
    fi

    if [ $1 == "build" ]
    then
      func_build
    fi

    if [ $1 == "cli" ]
    then
      func_cli
    fi

    if [ $1 == "cluster" ]
    then
      if [ $2 == "--help" ] || [ $2 == "-h" ]
      then
          echo "$__usage_cluster"
      fi

      if [ $2 == "create" ]
      then
        scripts/local/kind/create.sh
      fi

      if [ $2 == "delete" ]
      then
        scripts/local/kind/delete.sh
      fi
    fi

fi
