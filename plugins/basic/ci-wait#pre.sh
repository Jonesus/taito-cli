#!/bin/bash
echo "NOTE: ci wait is deprecated"
"${taito_plugin_path:?}/deployment-wait#pre.sh" "${@}"
