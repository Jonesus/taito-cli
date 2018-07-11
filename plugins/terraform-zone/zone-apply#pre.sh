#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"

name=${1}
prompt="Apply changes to ${taito_env} by running terraform scripts"

if "${taito_cli_path}/util/confirm-execution.sh" "terraform" "${name}" "${prompt}"; then
  (
    export TF_LOG_PATH="./terraform.log"
    # shellcheck disable=SC1090
    . "${taito_cli_path}/plugins/terraform/util/env.sh" && \
    cd "./terraform" && \
    terraform init && \
    if [[ -f import_state.sh ]]; then
      ./import_state.sh
    fi && \
    terraform apply
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
