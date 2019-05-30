#!/bin/bash
: "${taito_util_path:?}"

if [[ "${ssh_db_proxy:-}" ]]; then
  . ${taito_plugin_path}/util/opts.sh
  forward_value=$(echo "$ssh_db_proxy" | "${taito_util_path}/replace-variables.sh")
  (
    ${taito_setv:?}
    sh -c "ssh ${opts} -4 -f -o ExitOnForwardFailure=yes ${forward_value} sleep 180"
  )

  echo
  echo "Database connection details:"
  "${taito_util_path}/display-db-proxy-details.sh"
  echo
  echo
  echo "Press enter to shutdown proxy"
  read -r
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
