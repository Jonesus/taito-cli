#!/bin/bash

: "${taito_cli_path:?}"

# TODO serverless.com support for fission?
echo "TODO deploy fission function" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
