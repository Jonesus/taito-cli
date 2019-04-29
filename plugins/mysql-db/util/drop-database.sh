#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_vout:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

${taito_setv:?}
mysql -h "${database_host}" \
  -P "${database_port}" \
  -D mysql \
  -u "${database_username}" \
  -e "set @database='${database_name}'; set @databaseold='${database_name}old'; source ${taito_plugin_path}/resources/drop.sql ;" \
  > ${taito_vout}
