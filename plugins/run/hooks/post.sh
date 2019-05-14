#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"
: "${run_scripts_location:?}"

# Run post scripts from scripts/run directory
script="${run_scripts_location}/taito-${taito_command}#post.sh"
if [[ -f ${script} ]]; then
  export taito_hook_command_executed=true
  echo
  echo "### run/post"
  echo "Run script ${script} (Y/n)?"
  [[ ${taito_mode:-} == "ci" ]] || read -r confirm
  if [[ ${confirm} =~ ^[Yy]*$ ]]; then
    "${taito_util_path}/ssh-agent.sh" "${script}" "${@}"
  fi
fi

# Runs a process if run_after_for_XXX setting is set for one of the
# plugins in the current command chain
. ${taito_plugin_path}/util/run.sh run_after_for_

# kill started run processes
for run_pid in ${ssh_background_pids:-}
do
  kill "${run_pid}"
done

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
