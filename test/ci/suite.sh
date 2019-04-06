#!/bin/bash

# Integration test suite for CI/CD commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito secrets:dev;\
taito artifact-build;\
taito deployment-deploy:dev;\
taito depl-revision:dev;\
taito depl-revert:dev;\
taito deployment-wait:dev;\
taito deployment-verify:dev;\
taito docs;\
taito scan;\
taito unit;\
taito test;\
taito artifact-publish;\
taito artifact-release;\
"

if ! ../util/verify.sh; then
  exit 1
fi
