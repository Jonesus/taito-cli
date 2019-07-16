#!/bin/bash -e

taito::call_next () {
  chain=(${taito_command_chain[@]})
  next="${chain[0]}"

  if [[ "${next}" != "" ]]; then
    name="${next//\/taito-cli\/plugins\//}"
    name=$(echo "${name}" | cut -f 1 -d '/')
    if [[ ${taito_quiet:-} != "true" ]] && ( \
         [[ "${taito_debug}" == "true" ]] || [[ "${next}" != *"/hooks/"* ]] \
       ); then
      echo
      echo -e "${taito_command_context_prefix:-}${H1s}${name}${H1e}"
    fi
    export taito_plugin_path
    taito_plugin_path=$(echo "${next/\hooks/}" | sed -e 's/\/[^\/]*$//g')
    taito_command_chain="${chain[@]:1}" "${next}" "${@}"
    exit $?
  else
    exit 0
  fi
}
export -f taito::call_next

# Executes the given shell commands on host
# NOTE: executes in container if ci mode is enabled.
taito::execute_on_host () {
  commands="${*:1}"
  sleep_seconds="${2}"

  echo "+ ${commands}" > "${taito_vout}"

  # TODO: clean up this hack (for running docker commands on remote host)
  if [[ "${taito_host:-}" ]] && \
     [[ "${taito_command}" != "util-test" ]] && \
     [[ "${taito_command}" != "test" ]] && \
     [[ "${taito_command}" != "auth" ]] && \
     [[ "${taito_env}" != "local" ]] && \
     [[ "${commands}" == *"docker"* ]]; then
    . "${taito_cli_path}/plugins/ssh/util/opts"
    ssh -t ${opts} "${taito_ssh_user:?}@${taito_host}" \
      "sudo -- bash -c 'cd ${taito_host_dir:?}; . ./taito-config.sh; ${commands}'"
  elif [[ "${taito_mode:-}" == "ci" ]]; then
    eval "${commands}"
  elif [[ -n ${taito_run:-} ]]; then
    echo "${commands}" >> ${taito_run}
    sleep "${sleep_seconds:-2}"
  else
    echo
    echo "-----------------------------------------------------------------------"
    echo "NOTE: On Windows you need to execute these commands manually:"
    echo "${commands}"
    echo "-----------------------------------------------------------------------"
    echo
    echo "Press enter after you have executed all the commands"
    read -r
  fi
}
export -f taito::execute_on_host

# Executes the given shell commands on host
# NOTE: executes in container if ci mode is enabled.
taito::execute_on_host_fg () {
  commands="${*:1}"

  echo "+ ${commands}" > "${taito_vout}"

  # TODO: clean up this hack (for running docker commands on remote host)
  if [[ "${taito_host:-}" ]] && \
     [[ "${taito_command}" != "util-test" ]] && \
     [[ "${taito_command}" != "test" ]] && \
     [[ "${taito_command}" != "auth" ]] && \
     [[ "${taito_env}" != "local" ]] && \
     [[ "${commands}" == *"docker"* ]]; then
    . "${taito_cli_path}/plugins/ssh/util/opts"
    ssh -t ${opts} "${taito_ssh_user:?}@${taito_host}" \
      "sudo -- bash -c 'cd ${taito_host_dir:?}; . ./taito-config.sh; (${commands})'"
  elif [[ "${taito_mode:-}" == "ci" ]]; then
    eval "(${commands})"
  elif [[ -n ${taito_run_fg:-} ]]; then
    echo "(${commands})" >> ${taito_run_fg}
  else
    echo
    echo "-----------------------------------------------------------------------"
    echo "NOTE: On Windows you need to execute these commands manually:"
    echo "${commands}"
    echo "-----------------------------------------------------------------------"
    echo
  fi
}
export -f taito::execute_on_host_fg

taito::execute_with_ssh_agent () {
  commands=$1

  use_agent=true
  if [[ ${SSH_AUTH_SOCK} ]]; then
    # Already running
    use_agent=false
  fi

  runner="bash -c"
  if [[ ${use_agent} == true ]]; then
    runner="ssh-agent bash -c"
  fi

  ${runner} "${commands} \"\${@}\"" -- "${@:2}"
}
export -f taito::execute_with_ssh_agent
