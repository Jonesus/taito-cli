#!/bin/bash -e

echo "TODO: Does not work yet. Use 'taito db dump:ENV file.sql' and"
echo "'taito db import:ENV file.sql' instead"
exit 1

: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_dest_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

if [[ "${database_type:-}" == "pg" ]] || [[ -z "${database_type}" ]]; then
  source="${taito_env}"
  dest="${taito_dest_env}"
  username="${1:-postgres}"

  "$taito_util_path/confirm.sh" \
    "Copying ${source} to ${dest}. Do you want to continue?"

  db_prefix=${database_name%_*}
  db_dest=${database_name%_*}_${dest}
  db_source=${database_name%_*}_${source}

  echo "- 1. Dump data"
  dump_file="${taito_project_path}/tmp/dump.sql"
  mkdir -p "${taito_project_path}/tmp" &> /dev/null
  rm -f "${dump_file}" &> /dev/null
  # TODO use: . "${taito_util_path}/read-project-taito-config.sh" "${source}"
  echo "TODO implement: set user/password/database/host/port for source database"
  exit 1
  "${taito_plugin_path}/util/psql.sh" "" "-f ${dump_file}" "pg_dump" && \

  echo "- 2. Rename the old database" && \
  database_username=${database_master_username:-postgres} && \
  echo "HINT: You can get the ${database_username} user password from:"
  echo "${database_master_password_hint:-}"
  . "${taito_plugin_path}/util/ask-password.sh" && \ # TODO Does not work. Why?
  flags="-f ${taito_plugin_path}/resources/rename-db.sql \
    -v dbusermaster=${database_master_username:-postgres} \
    -v database=${db_dest} \
    -v database_new=${db_dest}_old" && \
  "${taito_plugin_path}/util/psql.sh" "${username}" "${flags}" && \

  echo "- 3. Create database" && \
  echo "NOTE: use taito secrets:${dest} to get the build password \
  for ${db_dest}" && \
  # TODO pass username
  # TODO set also cluster name and port
  database_username=${username} database_name=${db_prefix}_${dest} \
    "${taito_plugin_path}/util/create-database.sh" && \

  echo "- 4. Import dump with a new build username" && \
  echo "TODO replace table ownerships in dump e.g xxx_test --> xxx_prod"
  exit 1
  sed -e "s/${db_source}/${db_dest}/g" \
    "${dump_file}" > \
    "${taito_project_path}/tmp/dump-mod.sql" && \
  flags="-f ${taito_project_path}/tmp/dump-mod.sql" && \
  database_name=${db_prefix}_${dest} "${taito_plugin_path}/util/psql.sh" \
    "" "${flags}" && \

  rm -f "${taito_project_path}/tmp/dump-mod.sql" && \
  rm -f "${dump_file}"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
