#!/bin/bash
: "${taito_namespace:?}"

if [[ ${kubernetes_skip_restart:-} != "true" ]]; then
  echo && \
  if "$taito_util_path/confirm.sh" "Restart all pods in namespace ${taito_namespace}?"; then
    echo "Restarting pods" && \
    echo "TODO rolling update instead of delete?" && \
    (${taito_setv:?}; kubectl delete --all pods --namespace="${taito_namespace}")
  fi
fi
