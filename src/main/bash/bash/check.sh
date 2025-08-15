#!/usr/local/bin/bash

ISSUER='./src/test/bash/unit_test.sh'
. $mt/checks/file.sh "${ISSUER}"
${ISSUER}
. $mt/checks/success.sh $? 'Check error!'
