#!/usr/local/bin/bash

ISSUER="${mt}/secrets/sha1.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1 1)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'No file name!'

FILE_NAME='/tmp/foo.txt'
rm "${FILE_NAME}" &> /dev/null

ACTUAL_VALUE="$(${ISSUER} "${FILE_NAME}")"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" "No file \"${FILE_NAME}\"!"

touch "${FILE_NAME}"

ACTUAL_VALUE="$(${ISSUER} "${FILE_NAME}")"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" "File \"${FILE_NAME}\" is empty!"

echo -n 'foo bar baz' > "${FILE_NAME}"

ACTUAL_VALUE="$(${ISSUER} "${FILE_NAME}")"
. $asserts/eq.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" ''
. $asserts/eq.sh "$(cat "${FILE_NAME}.sha1")" 'c7567e8b39e2428e38bf9c9226ac68de4c67dc39'
