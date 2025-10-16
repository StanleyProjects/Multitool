#!/usr/local/bin/bash

ISSUER="${mt}/hashes/sha256.sh"

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
. $asserts/eq.sh "$(cat "${FILE_NAME}.sha256" | xxd -p -c 64)" 'dbd318c1c462aee872f41109a4dfd3048871a03dedd0fe0e757ced57dad6f2d7'
