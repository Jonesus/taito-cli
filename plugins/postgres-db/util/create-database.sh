#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_vout:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"
: "${database_username:?}"

(
  export PGPASSWORD
  PGPASSWORD="${PGPASSWORD}"
  (
    ${taito_setv:?}
    psql -h "${database_host}" \
      -p "${database_port}" \
      -d postgres \
      -U "${database_username}" \
      -f "${taito_plugin_path}/resources/create.sql" \
      -v "database=${database_name}" \
      -v "dbusermaster=${database_master_username:-postgres}" \
      -v "dbuserapp=${database_name}_app" > ${taito_vout}
  ) && \

  if [[ -f "./${taito_target:-database}/db.sql" ]]; then
    (
      ${taito_setv:?}
      psql -h "${database_host}" \
        -p "${database_port}" \
        -d "${database_name}" \
        -U "${database_username}" \
        < "./${taito_target:-database}/db.sql" > ${taito_vout}
    )
  else
    echo "WARNING: File ./${taito_target:-database}/db.sql does not exist"
  fi && \

  . "${taito_plugin_path}/util/postgres-username-password.sh" && \

  PGPASSWORD="${secret_value}"
  (
    ${taito_setv:?}
    psql -h "${database_host}" \
    -p "${database_port}" \
    -d "${database_name}" \
    -U "${database_name}" \
    -f "${taito_plugin_path}/resources/grant.sql" \
    -v "database=${database_name}" \
    -v "dbusermaster=${database_master_username:-postgres}" \
    -v "dbuserapp=${database_name}_app" > ${taito_vout}
  )
)
