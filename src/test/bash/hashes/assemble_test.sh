#!/usr/local/bin/bash

ISSUER="${mt}/hashes/assemble.sh"

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

. $mt/hashes/md5.sh    "${FILE_NAME}"
. $mt/hashes/sha1.sh   "${FILE_NAME}"
. $mt/hashes/sha256.sh "${FILE_NAME}"
. $mt/hashes/sha512.sh "${FILE_NAME}"

ISSUER="${mt}/hashes/assemble.sh"

ACTUAL_VALUE="$(${ISSUER} "${FILE_NAME}")"
. $asserts/eq.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" ''

ACTUAL_VALUE="$(cat "${FILE_NAME}-hashes.txt")"
EXPECTED_VALUE="md5:    ab07acbb1e496801937adfa772424bf7
sha1:   c7567e8b39e2428e38bf9c9226ac68de4c67dc39
sha256: dbd318c1c462aee872f41109a4dfd3048871a03dedd0fe0e757ced57dad6f2d7
sha512: bce50343a56f01dc7cf2d4c82127be4fff3a83ddb8b783b1a28fb6574637ceb71ef594b1f03a8e9b7d754341831292bcad1a3cb8a12fd2ded7a57b1b173b3bf7"

. $asserts/eq.sh "${ACTUAL_VALUE}" "${EXPECTED_VALUE}"
