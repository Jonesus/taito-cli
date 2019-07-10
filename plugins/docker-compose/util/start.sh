#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"
: "${taito_project:?}"
: "${taito_target_env:?}"

switches=" ${*} "

compose_file=$("$taito_plugin_path/util/prepare-compose-file.sh" false)

setenv="dockerfile=Dockerfile "
if [[ "${switches}" == *"--prod"* ]]; then
  setenv="dockerfile=Dockerfile.build "
fi

compose_cmd="up"
if [[ -n "${taito_target:-}" ]]; then
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/determine-pod.sh" && \
  compose_cmd="run ${pod:?}"
fi

flags=""
if [[ "${switches}" == *"--clean"* ]]; then
  flags="${flags} --force-recreate --build --remove-orphans \
    --renew-anon-volumes"
fi
if [[ "${switches}" == *"-b"* ]] || [[ ${taito_target_env} != "local" ]]; then
  flags="${flags} --detach"
fi

conditional_commands=
if [[ "${switches}" == *"--restart"* ]]; then
  # Run 'docker-compose stop' before start
  conditional_commands="
    ${conditional_commands}
    docker-compose -f $compose_file stop
  "
fi
if [[ "${switches}" == *"--init"* ]] && [[ " ${taito_targets:-} " == *" database "* ]]; then
  # Run 'taito init' automatically after database container has started
  init_flags=
  # if [[ "${switches}" == *"--clean"* ]]; then
  #   init_flags="--clean"
  # fi

  # TODO: remove hardcoded database target: ${taito_project}-database
  # TODO: how to avoid hardcoded 'sleep 40'? DB container does not provide health checks.
  conditional_commands="
    ${conditional_commands}
    init() {
      count=0
      sleep 5
      while [ \$count -lt 3000 ] && \
            [ -z \"\$(docker ps -q --filter 'status=running' --filter 'name=${taito_project}-database')\" ]
      do
        sleep 2
        count=\$((\${count}+1))
      done
      sleep 10
      export taito_command_context='init'
      taito -q ${taito_options:-} init ${init_flags} | cat
    }
    init &
  "
fi

# TODO: remove taito-run-env.sh (backwards compatibility -> only used in old projects)
"${taito_util_path}/execute-on-host-fg.sh" "
  if [ -f ./taito-run-env.sh ]; then . ./taito-run-env.sh; fi
  ${conditional_commands}
  ${setenv}docker-compose -f $compose_file ${compose_cmd} ${flags}
"
