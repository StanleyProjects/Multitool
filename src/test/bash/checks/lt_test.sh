#!/usr/local/bin/bash

ISSUER="${mt}/checks/lt.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1 2)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1 2 3 4)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1 2 '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'No message!'

EXPECTED_VALUE='test message'

ACTUAL_VALUE="$(${ISSUER} 2 1 "${EXPECTED_VALUE}")"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" "${EXPECTED_VALUE}"

ACTUAL_VALUE="$(${ISSUER} 1 1 "${EXPECTED_VALUE}")"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" "${EXPECTED_VALUE}"

ACTUAL_VALUE="$(${ISSUER} 1 2 "${EXPECTED_VALUE}")"
. $asserts/eq.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" ''
