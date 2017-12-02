#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

change="${1:?Change not given}"

# To avoid accidents, we always require CHANGE as argument
# TODO only revert the "previous batch" of changes when CHANGE is not given
# as argument

"${taito_plugin_path}/util/sqitch.sh" revert "${change}" \
  --set env="'${taito_env}'" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
