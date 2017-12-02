#!/bin/bash

: "${taito_cli_path:?}"

dest="${taito_branch:?Destination branch name not given}"
source="${1:?Source branch name not given}"

echo "Merging ${source} to ${dest}. Do you want to continue (Y/n)?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
  exit 130
fi

# TODO execute remote merge using hub cli?
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  git fetch origin ${source}:${dest} && \
  git push origin ${dest}; \
  " && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
