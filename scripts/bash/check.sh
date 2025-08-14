#!/usr/local/bin/bash

ISSUER='./scripts/src/test/bash/unit_test.sh'
. $mt/checks/file "${ISSUER}"
${ISSUER}
. $mt/checks/success $? 'Check error!'
