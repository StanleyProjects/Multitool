#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 1 'Wrong arguments!'

ISSUER="$1"

. $mt/checks/filled.sh "${ISSUER}" 'No file name!'

. $mt/checks/file.sh "${ISSUER}"

rm "${ISSUER}.sha512" &> /dev/null

openssl dgst -sha512 -binary "${ISSUER}" > "${ISSUER}.sha512"

HEX="$(cat "${ISSUER}.sha512" | xxd -p -c 128)"

. $mt/checks/eq.sh 128 "${#HEX}" "Hash \"${ISSUER}\" error!"
