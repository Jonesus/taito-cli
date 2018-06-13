#!/bin/bash

current_name=${1}
requested_name=${2}

if [[ "${requested_name}" == "" ]] || \
   [[ "${requested_name}" == "${current_name}" ]]; then
  echo "Execute ${current_name} (Y/n)?"
  read -r confirm
  if [[ ${confirm} =~ ^[Yy]*$ ]]; then
    exit 0
  fi
fi

exit 2
