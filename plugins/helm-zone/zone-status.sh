#!/bin/bash
: "${taito_setv:?}"
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

"${taito_plugin_path}/../helm/util/helm.sh" list

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
