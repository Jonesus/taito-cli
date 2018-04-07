#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

switches=" ${*} "

setenv="dockerfile=Dockerfile "
if [[ "${switches}" == *"--prod"* ]]; then
  setenv="dockerfile=Dockerfile.build "
fi

compose_cmd="up"
if [[ -n "${1}" ]] && [[ "${1}" != "--"* ]]; then
  docker_run="${1}"
fi
if [[ -n "${docker_run:-}" ]]; then
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh" "${docker_run}" && \
  compose_cmd="run ${pod:?}"
fi

flags=""
if [[ "${switches}" == *"--clean"* ]]; then
  flags="${flags} --force-recreate --build --remove-orphans"
fi
if [[ "${switches}" == *"-b"* ]]; then
  flags="${flags} --detach"
fi

"${taito_cli_path}/util/execute-on-host-fg.sh" \
  "${setenv}docker-compose ${compose_cmd} ${flags}"
