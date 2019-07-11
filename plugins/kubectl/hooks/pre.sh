#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"
: "${taito_env:?}"

# kubernetes database proxy

if [[ ${kubernetes_db_proxy_enabled:-} == "true" ]] && \
   [[ ${taito_requires_database_connection:-} == "true" ]]; then
  proxy_running=$(pgrep "kubectl")
  echo
  echo -e "${taito_command_context_prefix:-}${H1s}kubectl${H1e}"
  if [[ "${proxy_running}" == "" ]]; then
    echo "Starting db proxy"
    "${taito_plugin_path}/util/use-context.sh"
    "${taito_plugin_path}/util/db-proxy-start.sh" "true"
  else
    echo "Not Starting db proxy. It is already running."
  fi
fi && \

# kubernetes secrets
# TODO: tighter filter
# NOTE: ci-release is deprecated
fetch_secrets=
secret_filter=
if [[ $kubectl_secrets_retrieved != true ]]; then
  if [[ ${taito_command} == "build-prepare" ]] || \
     [[ ${taito_command} == "build-release" ]] || \
     [[ ${taito_command} == "artifact-prepare" ]] || \
     [[ ${taito_command} == "artifact-release" ]] || \
     [[ ${taito_command} == "ci-release" ]]; then
    fetch_secrets="true"
    secret_filter="git"
  elif [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || \
       [[ ${taito_command} == "db-proxy" ]]; then
    fetch_secrets="true"
    secret_filter="db"
  elif [[ ${taito_command} == "test" ]] &&
       [[ "stag canary prod" != *"${taito_env}"* ]]; then
    fetch_secrets="true"
    secret_filter=
  fi
fi

if [[ ${fetch_secrets} ]]; then
  echo
  echo -e "${taito_command_context_prefix:-}${H1s}kubectl${H1e}"
  echo "Getting secrets from Kubernetes"
  "${taito_cli_path}/plugins/kubectl/util/use-context.sh"
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/get-secrets.sh" "true" ${secret_filter}
  export kubectl_secrets_retrieved=true
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
