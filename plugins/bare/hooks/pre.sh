#!/bin/bash
: "${taito_cli_path:?}"

if [[ ${taito_commands_only_chain:-} == *"-db/"* ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  if [[ "${proxy_running}" == "" ]]; then
    echo "### bare/pre: Starting db proxy."
    echo "TODO implement"
  else
    echo "### bare/pre: Not Starting db proxy. It is already running."
  fi
fi && \

if [[ "${taito_mode:-}" == "ci" ]] && \
   [[ ${taito_commands_only_chain:-} == *"kubectl/"* ]]; then
  echo "### bare/pre: Getting credentials for kubernetes"
  echo "TODO implement"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
