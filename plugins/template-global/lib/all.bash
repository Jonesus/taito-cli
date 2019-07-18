#!/bin/bash -e

function template-global::ask_and_export_details () {
  : "${template_source_git:?}"
  : "${template_default_dest_git:?}"
  : "${template:?}"

  export template_mode=${1} # TODO: remove export?

  export taito_company
  export taito_family
  export taito_application
  export taito_suffix
  export taito_vc_repository

  echo
  echo "Repository name, application namespace, and labels will be constituted from"
  echo "the following details:"
  echo
  echo "  1) Customer, company or business unit"
  echo "  2) Product family (optional)"
  echo "  3) Application name"
  echo "  4) Service or name suffix (optional)"
  echo
  echo "NOTE: Please give a short lower case word or abbreviation for each."
  echo "No special characters!"
  echo
  read -r -t 1 -n 1000 || : # Flush input buffer
  echo "1) Customer, company or business unit (e.g. 'taito')?"
  read -r taito_company
  if ! [[ "${taito_company}" =~ ^[a-z][a-z1-9]+$ ]] || \
     [[ ${#taito_company} -gt 14 ]]; then
    echo "ERROR: invalid value or too long"
    exit 1
  fi
  echo
  read -r -t 1 -n 1000 || : # Flush input buffer
  echo "2) Optional: Product family (e.g. 'office')?"
  read -r taito_family
  if ! [[ "${taito_family}" =~ ^[a-z]?[a-z1-9]*$ ]] || \
     [[ ${#taito_family} -gt 14 ]]; then
    echo "ERROR: invalid value or too long"
    exit 1
  fi
  echo
  read -r -t 1 -n 1000 || : # Flush input buffer
  echo "3) Application name (e.g. 'chat')?"
  read -r taito_application
  if ! [[ "${taito_application}" =~ ^[a-z][a-z1-9]+$ ]] || \
     [[ ${#taito_application} -gt 14 ]]; then
    echo "ERROR: invalid value or too long"
    exit 1
  fi
  echo
  read -r -t 1 -n 1000 || : # Flush input buffer
  echo "4) Optional: service or name suffix (e.g. 'api', 'gui', ...)"
  read -r taito_suffix # TODO application_suffix
  if ! [[ "${taito_suffix}" =~ ^[a-z]?[a-z1-9]*$ ]] || \
     [[ ${#taito_suffix} -gt 10 ]]; then
    echo "ERROR: invalid value or too long"
    exit 1
  fi

  if [[ "${taito_suffix}" != "" ]]; then
    taito_vc_repository="${taito_family:-$taito_company}-${taito_application}-${taito_suffix}"
  else
    taito_vc_repository="${taito_family:-$taito_company}-${taito_application}"
  fi
}

function template-global::init () {
  : "${taito_vc_repository:?}"
  : "${template_source_git:?}"
  : "${template_default_dest_git:?}"
  : "${template:?}"

  export template_mode=${1} # TODO: remove export
  export taito_vc_repository_alt="${taito_vc_repository//-/_}"

  # Call create/migrate/upgrade script implemented in template
  # TODO: remove .sh suffix
  "./scripts/taito-template/${template_mode}.sh"

  # Remove template scripts
  rm -rf ./scripts/taito-template
}
