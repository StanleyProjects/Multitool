#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 1 'Wrong arguments!'

ISSUER="$1"

. $mt/checks/filled.sh "${ISSUER}" 'No file name!'

. $mt/checks/file.sh "${ISSUER}"

rm "${ISSUER}.sha1" &> /dev/null

openssl dgst -sha1 -binary "${ISSUER}" > "${ISSUER}.sha1"

HEX="$(cat "${ISSUER}.sha1" | xxd -p -c 64)"

. $mt/checks/eq.sh 40 "${#HEX}" "Hash \"${ISSUER}\" error!"
