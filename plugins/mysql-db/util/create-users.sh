#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_vout:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

. "${taito_util_path}/database-username-password.sh"

# Validate env variables

if [[ ${#database_build_password} -lt 20 ]]; then
  echo "ERROR: Database mgr user password too short or not set"
  exit 1
fi

if [[ ${#database_app_password} -lt 20 ]]; then
  echo "ERROR: Database app user password too short or not set"
  echo "TODO: Fails in WordPress projects (there is no app user at all)"
  exit 1
fi

# Execute

${taito_setv:?}
mysql -h "${database_host}" \
  -P "${database_port}" \
  -D mysql \
  -u "${database_username}" \
  -e "set @database='${database_name}'; set @dbusermaster='${database_master_username:-root}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}a'; set @passwordapp='${database_app_password}'; set @passwordmgr='${database_build_password}'; source ${taito_plugin_path}/resources/users.sql ;" \
  > ${taito_vout} 2>&1
