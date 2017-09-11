#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo
echo "### postgres - o-init: Deploying changes to database ${taito_env} ###"

"${taito_plugin_path}/util/deploy-changes.sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
