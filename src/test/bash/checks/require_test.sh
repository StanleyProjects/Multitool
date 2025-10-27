#!/usr/local/bin/bash

ISSUER="${mt}/checks/require.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'No arguments!'

ACTUAL_VALUE="$(${ISSUER} V0)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "V0" is empty!'

ACTUAL_VALUE="$(V0='foo' ${ISSUER} V0 V1)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "V1" is empty!'

ACTUAL_VALUE="$(V0='foo' V1='bar' ${ISSUER} V0 V1)"
. $asserts/eq.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" ''
