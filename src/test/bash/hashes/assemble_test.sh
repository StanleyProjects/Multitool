#!/usr/local/bin/bash

ISSUER="${mt}/hashes/assemble.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1 2 3)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} '' 2)"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'No src name!'

ACTUAL_VALUE="$(${ISSUER} 1 '')"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" 'No dst name!'

SRC_NAME='/tmp/foo.txt'
DST_NAME='/tmp/foo-hashes.txt'
rm "${SRC_NAME}" &> /dev/null
rm "${SRC_NAME}.md5" &> /dev/null
rm "${SRC_NAME}.sha1" &> /dev/null
rm "${SRC_NAME}.sha256" &> /dev/null
rm "${SRC_NAME}.sha512" &> /dev/null
rm "${DST_NAME}" &> /dev/null

ACTUAL_VALUE="$(${ISSUER} "${SRC_NAME}" "${DST_NAME}")"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" "No file \"${SRC_NAME}\"!"

touch "${SRC_NAME}"

ACTUAL_VALUE="$(${ISSUER} "${SRC_NAME}" "${DST_NAME}")"
. $asserts/ne.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" "File \"${SRC_NAME}\" is empty!"

echo -n 'foo bar baz' > "${SRC_NAME}"

ACTUAL_VALUE="$(${ISSUER} "${SRC_NAME}" "${DST_NAME}")"
. $asserts/eq.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" ''

ACTUAL_VALUE="$(cat "${DST_NAME}")"
EXPECTED_VALUE="md5:    ab07acbb1e496801937adfa772424bf7
sha1:   c7567e8b39e2428e38bf9c9226ac68de4c67dc39
sha256: dbd318c1c462aee872f41109a4dfd3048871a03dedd0fe0e757ced57dad6f2d7
sha512: bce50343a56f01dc7cf2d4c82127be4fff3a83ddb8b783b1a28fb6574637ceb71ef594b1f03a8e9b7d754341831292bcad1a3cb8a12fd2ded7a57b1b173b3bf7"

. $asserts/eq.sh "${ACTUAL_VALUE}" "${EXPECTED_VALUE}"
