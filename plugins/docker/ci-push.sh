#!/bin/bash
echo "NOTE: ci push is deprecated"
"${taito_plugin_path:?}/artifact-push.sh" "${@}"
