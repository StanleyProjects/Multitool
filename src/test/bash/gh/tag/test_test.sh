#!/usr/local/bin/bash

ISSUER="${mt}/gh/tag/test.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1 2)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "REPOSITORY_OWNER" is empty!'

ACTUAL_VALUE="$(REPOSITORY_OWNER='StanleyProjects' ${ISSUER} 1)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "REPOSITORY_NAME" is empty!'

ACTUAL_VALUE="$(REPOSITORY_OWNER='StanleyProjects' REPOSITORY_NAME='Multitool' ${ISSUER} '0.11.3')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Tag error!'

ACTUAL_VALUE="$(REPOSITORY_OWNER='StanleyProjects' REPOSITORY_NAME='Multitool' ${ISSUER} 'foo')"
. $asserts/eq.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" ''
