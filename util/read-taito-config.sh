#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.
: "${taito_project_path:?}"

export taito_env="${1:-$taito_env}"

# Read taito-config.sh files from all locations
if [[ -f "${HOME}/.taito/taito-config.sh" ]]; then
  # Personal config
  # shellcheck disable=SC1090
  . "${HOME}/.taito/taito-config.sh"
fi
if [[ -f "${taito_project_path}/taito-config.sh" ]]; then
  # Project specific config
  # shellcheck disable=SC1091
  . "${taito_project_path}/taito-config.sh"
fi
