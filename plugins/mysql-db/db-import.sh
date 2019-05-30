#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

if [[ "${database_type:-}" == "mysql" ]] || [[ -z "${database_type}" ]]; then
  echo "Importing ${1}"
  "${taito_plugin_path}/util/mysql.sh" < "${1}"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
