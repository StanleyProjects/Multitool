#!/usr/local/bin/bash

ISSUER="${mt}/hashes/sha512.sh"

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
. $asserts/eq.sh "$(cat "${FILE_NAME}.sha512" | xxd -p -c 128)" 'bce50343a56f01dc7cf2d4c82127be4fff3a83ddb8b783b1a28fb6574637ceb71ef594b1f03a8e9b7d754341831292bcad1a3cb8a12fd2ded7a57b1b173b3bf7'
