#!/bin/bash

: "${taito_cli_path:?}"

# TODO [data | build] as arguments

"${taito_cli_path}/util/execute-on-host.sh" \
  "docker-compose down --volumes --remove-orphans"
