#!/usr/local/bin/bash

ISSUER="${mt}/checks/one_of.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Too few arguments!'

ACTUAL_VALUE="$(${ISSUER} 1)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Too few arguments!'

ACTUAL_VALUE="$(${ISSUER} 1 2)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Too few arguments!'

ACTUAL_VALUE="$(${ISSUER} '' 2 3)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Value is empty!'

ACTUAL_VALUE="$(${ISSUER} 1 2 3)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Value "1" not found!'

ACTUAL_VALUE="$(${ISSUER} 1 2 1)"
. $asserts/eq.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" ''
