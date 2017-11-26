#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### pipenv - oper-install: Installing packages to virtualenv ###"

"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  pipenv --python 3.6 && \
  pipenv install --dev" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
