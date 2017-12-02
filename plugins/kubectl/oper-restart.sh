#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

kubectl delete pods --all && \
echo "kubectl: TODO rolling restart instead of kill" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
