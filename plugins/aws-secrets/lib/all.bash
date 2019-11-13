#!/bin/bash
# shellcheck source=../../aws/lib/all.bash
. "${taito_plugin_path:?}/../aws/lib/all.bash"

function get_key () {
  local zone=$1
  local namespace=$2
  local name=$3

  local secret_name
  local secret_property
  secret_name=$(taito::get_secret_name "${name}")
  secret_property=$(taito::get_secret_property "${name}")

  echo "/${zone}/${namespace}/${secret_name}.${secret_property}"
}

function get_parameter () {
  aws::expose_aws_options
  value=$(
    aws ${aws_options} ssm get-parameter \
      --name "${1}" \
      --with-decryption 2> /dev/null |
        jq -r -e '.Parameter.Value'
  ) || value=""
  echo "${value}"
}

function aws-secrets::get_secret_value () {
  local zone=$1
  local namespace=$2
  local name=$3
  local key

  key=$(get_key "${zone}" "${namespace}" "${name}")
  get_parameter "${key}"
}

function aws-secrets::put_secret_value () {
  local zone=$1
  local namespace=$2
  local name=$3
  local method=$4
  local value=$5
  local filename=$6
  local format
  local key

  if [[ ${filename} ]]; then
    format=$(taito::get_secret_value_format "${method}")
    if [[ ${format} == "file" ]]; then
      # Files are stored in AWS SSM as base64 encoded strings
      value=$(base64 -i "${filename}")
    else
      value=$(cat "${filename}")
    fi
  fi

  aws::expose_aws_options
  key=$(get_key "${zone}" "${namespace}" "${name}")
  aws ${aws_options} ssm put-parameter \
    --name "${key}" \
    --value "${value}" \
    --type "SecureString" \
    --overwrite > /dev/null
  aws ${aws_options} ssm put-parameter \
    --name "${key}.METHOD" \
    --value "${method}" \
    --type "SecureString" \
    --overwrite > /dev/null
}

function aws-secrets::delete_secret_value () {
  local zone=$1
  local namespace=$2
  local name=$3
  local key

  aws::expose_aws_options
  key=$(get_key "${zone}" "${namespace}" "${name}")
  aws ${aws_options} ssm delete-parameter --name "${key}"
  aws ${aws_options} ssm delete-parameter --name "${key}.METHOD"
}
