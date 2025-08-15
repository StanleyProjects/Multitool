#!/usr/local/bin/bash

ISSUER="${mt}/checks/file.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1 2)"
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

echo 'foo bar baz' > "${FILE_NAME}"

ACTUAL_VALUE="$(${ISSUER} "${FILE_NAME}")"
. $asserts/eq.sh $? 0
. $asserts/empty.sh "${ACTUAL_VALUE}"
