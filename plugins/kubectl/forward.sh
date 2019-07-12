#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

source_port=$1
dest_port=${2:-$source_port}

if "$taito_util_path/is-target-type.sh" container; then
  "${taito_plugin_path}/util/use-context.sh"
  . "${taito_plugin_path}/util/determine-pod-container.sh"
  # NOTE: --address 0.0.0.0 requires Kubernetes v1.13
  (${taito_setv:?}; kubectl port-forward "${pod}" "$source_port:$dest_port" --address 0.0.0.0)
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
