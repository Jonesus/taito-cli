#!/bin/bash
: "${taito_util_path:?}"
: "${taito_app_url:?}"
: "${taito_target_env:?}"

# Wait for deployment only if tests are executed after
if [[ "${taito_mode:-}" == "ci" ]] && [[ "${ci_exec_test:-}" != "true" ]]; then
  echo "Skipping deployment wait because ci_exec_test != true"
  echo
  echo
  echo -e "${NOTEs}"
  echo "NOTE: Your application is now starting up at ${taito_target_env}!"
  echo -e "${NOTEe}"
  echo
  echo
else
  extra_sleep_secs=${ci_test_wait:-35}
  # Call next command on command chain
  "${taito_util_path}/call-next.sh" "${@}"
  echo
  echo
  echo -e "${NOTEs}"
  echo "NOTE: Your application is now running at ${taito_target_env}!"
  echo "Waiting extra ${extra_sleep_secs}s to make sure full container rotate."
  echo "You can configure sleep seconds with the ci_test_wait environment variable."
  echo -e "${NOTEe}"
  echo
  echo
  sleep "${extra_sleep_secs}"
fi
