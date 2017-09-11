#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - env-delete: Deleting secrets from Kubernetes ###"

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

"${taito_plugin_path}/util/delete-secrets.sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
