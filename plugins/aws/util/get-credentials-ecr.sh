#!/bin/bash
: "${kubernetes_name:?}"
: "${taito_provider_region:?}"

. "${taito_cli_path}/plugins/aws/util/aws-options.sh"

# NOTE: one-liner login to avoid passing password via CLI:
# https://github.com/aws/aws-cli/issues/2875#issuecomment-487244855
${taito_setv:?}
aws $aws_options ecr get-login --no-include-email --region "${taito_provider_region}" | awk '{print $6}' | docker login -u AWS --password-stdin $(aws $aws_options ecr get-login --no-include-email --region "${taito_provider_region}" | awk '{print $7}')
