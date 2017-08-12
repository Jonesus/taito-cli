#!/bin/bash


# Integration test suite for basic commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito help;\
taito readme;\
taito trouble;\
"

if ! ../util/verify.sh; then
  exit 1
fi
