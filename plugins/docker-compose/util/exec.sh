#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"

commands=$(printf '"%s" ' "${@}")

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/determine-pod.sh" && \

if [[ -n "${docker_run:-}" ]]; then
  # Using run mode instead of up
  # TODO take --no-deps as param
  "${taito_util_path}/execute-on-host-fg.sh" \
    "docker-compose run --no-deps --entrypoint ${commands} ${pod}"
else
  "${taito_util_path}/execute-on-host-fg.sh" "docker exec -it ${pod} ${commands}"
fi
