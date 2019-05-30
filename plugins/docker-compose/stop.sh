#!/bin/bash
: "${taito_util_path:?}"

options=" ${*} "
if [[ "${options}" == *" --down "* ]]; then
  echo "ERROR: 'taito stop --down' is deprecated. Run 'taito down' instead".
  exit 1
fi

if [[ -n "${taito_target:-}" ]]; then
  # Restart only the container given as argument
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh"
fi

compose_file=$("$taito_plugin_path/util/prepare-compose-file.sh" false)
"${taito_util_path}/execute-on-host-fg.sh" "
  docker-compose -f $compose_file stop ${pod:-}
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
