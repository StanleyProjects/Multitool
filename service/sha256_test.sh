#!/usr/local/bin/bash

ISSUER='secrets/sha256.sh'

ACTUAL_VALUE="$($mt/${ISSUER})"
. $mt/../service/assert.sh "${ISSUER}" $? 1
. $mt/../service/assert.sh "${ISSUER}" "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$($mt/${ISSUER} 1 1)"
. $mt/../service/assert.sh "${ISSUER}" $? 1
. $mt/../service/assert.sh "${ISSUER}" "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$($mt/${ISSUER} '')"
. $mt/../service/assert.sh "${ISSUER}" $? 101
. $mt/../service/assert.sh "${ISSUER}" "${ACTUAL_VALUE}" 'Argument "ISSUER" is empty!'

EXPECTED_FILE='/tmp/foo.txt'

rm "${EXPECTED_FILE}"

if test -f "${EXPECTED_FILE}"; then
 echo "File \"${EXPECTED_FILE}\" exists!"; exit 1; fi

ACTUAL_VALUE="$($mt/${ISSUER} "${EXPECTED_FILE}")"
. $mt/../service/assert.sh "${ISSUER}" $? 1

echo 'foobarbaz' > "${EXPECTED_FILE}"

if [[ ! -s "${EXPECTED_FILE}" ]]; then
 echo "File \"${EXPECTED_FILE}\" error!"; exit 1; fi

EXPECTED_VALUE='2f72cc11a6fcd0271ecef8c61056ee1eb1243be3805bf9a9df98f92f7636b05c'

ACTUAL_VALUE="$($mt/${ISSUER} "${EXPECTED_FILE}")"
. $mt/../service/assert.sh "${ISSUER}" $? 0
. $mt/../service/assert.sh "${ISSUER}" "${ACTUAL_VALUE}" ''
. $mt/../service/assert.sh "${ISSUER}" "$(cat "${EXPECTED_FILE}.sha256")" "${EXPECTED_VALUE}"
