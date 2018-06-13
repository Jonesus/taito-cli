#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"
: "${database_username:?}"

(
  export PGPASSWORD
  echo
  echo "- import create.sql"
  PGPASSWORD="${PGPASSWORD}"
  (
    ${taito_setv:?}
    psql -h "${database_host}" \
      -p "${database_port}" \
      -U "${database_username}" \
      -f "${taito_plugin_path}/resources/create.sql" \
      -v "database=${database_name}" \
      -v "dbuserapp=${database_name}_app"
  ) && \

  if [[ -f "./${taito_target:-database}/db.sql" ]]; then
    echo
    echo "- import ./${taito_target:-database}/db.sql"
    (
      ${taito_setv:?}
      psql -h "${database_host}" \
        -p "${database_port}" \
        -d "${database_name}" \
        -U "${database_username}" \
        < "./${taito_target:-database}/db.sql"
    )
  else
    echo "WARN: File ./${taito_target:-database}/db.sql does not exist"
  fi && \

  . "${taito_plugin_path}/util/postgres-username-password.sh" && \

  echo && \
  echo "- import grant.sql" && \
  PGPASSWORD="${secret_value}"
  (
    ${taito_setv:?}
    psql -h "${database_host}" \
    -p "${database_port}" \
    -d "${database_name}" \
    -U "${database_name}" \
    -f "${taito_plugin_path}/resources/grant.sql" \
    -v "database=${database_name}" \
    -v "dbuserapp=${database_name}_app"
  )
)
