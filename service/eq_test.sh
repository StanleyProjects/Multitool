#!/usr/local/bin/bash

ISSUER='checks/eq'

ACTUAL_VALUE="$($mt/${ISSUER})"
. $mt/../service/assert.sh "${ISSUER}" $? 1
. $mt/../service/assert.sh "${ISSUER}" "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$($mt/${ISSUER} 1 1)"
. $mt/../service/assert.sh "${ISSUER}" $? 1
. $mt/../service/assert.sh "${ISSUER}" "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$($mt/${ISSUER} 1 1 1 1)"
. $mt/../service/assert.sh "${ISSUER}" $? 1
. $mt/../service/assert.sh "${ISSUER}" "${ACTUAL_VALUE}" 'Wrong arguments!'

EXPECTED_VALUE='test message'

ACTUAL_VALUE="$($mt/${ISSUER} 1 2 "${EXPECTED_VALUE}")"
. $mt/../service/assert.sh "${ISSUER}" $? 1
. $mt/../service/assert.sh "${ISSUER}" "${ACTUAL_VALUE}" "${EXPECTED_VALUE}"

ACTUAL_VALUE="$($mt/${ISSUER} 1 1 "${EXPECTED_VALUE}")"
. $mt/../service/assert.sh "${ISSUER}" $? 0
. $mt/../service/assert.sh "${ISSUER}" "${ACTUAL_VALUE}" ''
