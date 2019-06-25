#!/bin/bash
: "${taito_project:?}"
: "${taito_target:?Target not given}"
: "${taito_target_env:?}"

prefix="${taito_project}"
if [[ "${taito_version:-}" -ge "1" ]]; then
  prefix="${taito_project}-${taito_target_env}"
fi

function get_pods() {
  kubectl get pods ${2} | \
    ${1} | \
    grep "${prefix}" | \
    sed -e "s/${prefix}-//" | \
    grep "${taito_target}" | \
    head -n1 | awk "{print \"${prefix}-\" \$1;}"
}

if [[ ${taito_target} != *"-"* ]]; then
  # Short pod name was given. Determine the full pod name.
  if [[ $DETERMINE_FAILED_POD = "true" ]]; then
    pod=$(get_pods "grep -v Running")
  else
    pod=$(get_pods "grep -v CrashLoopBackOff" "--field-selector=status.phase=Running")
  fi
  if [[ ! ${pod} ]]; then
    pod=$(get_pods "cat")
  fi
fi

if [[ -z "${container}" ]] || \
   [[ "${container}" == "--" ]] || \
   [[ "${container}" == "-" ]]; then
  # No container name was given. Determine container name.
  container=$(echo "${pod}" | \
    sed -e 's/\([^0-9]*\)*/\1/;s/-[a-z0-9]*-[a-z0-9]*$//' | \
    sed -e "s/-${taito_target_env}//")
fi
