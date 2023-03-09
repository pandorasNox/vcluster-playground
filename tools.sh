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
"

# -----------------------------------------------------------------------------

function func_build() {
  # for debug
  # docker build --progress=plain .

  docker build -q .
}

function func_cli() {
  docker run -it --rm \
    -v "$(pwd):/workdir" \
    -v "${KUBECONFIG_FILE_PATH}:/root/.kube/config:ro" \
    -w "/workdir" \
    $(func_build)
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

fi
