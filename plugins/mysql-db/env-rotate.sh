#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

(
  databases=("${taito_target:-$taito_databases}")
  for database in ${databases[@]}
  do
    export taito_target="${database}"
    . "${taito_util_path}/read-database-config.sh" "${database}" && \

    if [[ "${database_type:-}" == "mysql" ]] || [[ -z "${database_type}" ]]; then
      . "${taito_plugin_path}/util/mysql-username-password.sh" && \

      if [[ -n ${database_build_password:-} ]] && \
         [[ -n ${database_app_password:-} ]] && ( \
           [[ ${database_build_password_changed:-} ]] || \
           [[ ${database_app_password_changed:-} ]]
         ); then
        if "${taito_cli_path}/util/confirm-execution.sh" "mysql" "" \
          "Set new passwords for mysql database ${database_name:-}"
        then
          export database_username=root
          . "${taito_plugin_path}/util/ask-password.sh" && \
          "${taito_plugin_path}/util/create-users.sh" && \
          echo "Altered database user passwords for database ${database_name:-}"
        fi
      fi
    fi
  done
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
