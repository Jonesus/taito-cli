#!/bin/bash -e

echo "Set db_variable_value: VALUE SET BY PRE"
export db_variable_value="VALUE SET BY PRE"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
