#!/usr/local/bin/bash

ISSUER="${mt}/gh/checkout.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "REPOSITORY_OWNER" is empty!'

ACTUAL_VALUE="$(REPOSITORY_OWNER='v0' ${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "REPOSITORY_NAME" is empty!'

ACTUAL_VALUE="$(REPOSITORY_OWNER='v0' REPOSITORY_NAME='v1' ${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "SOURCE_COMMIT" is empty!'

ACTUAL_VALUE="$(REPOSITORY_OWNER='v0' REPOSITORY_NAME='v1' SOURCE_COMMIT='v2' ${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "TARGET_BRANCH" is empty!'

ACTUAL_VALUE="$(REPOSITORY_OWNER='v0' REPOSITORY_NAME='v1' SOURCE_COMMIT='v2' TARGET_BRANCH='v3' ${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Argument "VCS_PAT" is empty!'
