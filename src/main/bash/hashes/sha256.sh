#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 1 'Wrong arguments!'

ISSUER="$1"

. $mt/checks/filled.sh "${ISSUER}" 'No file name!'

. $mt/checks/file.sh "${ISSUER}"

rm "${ISSUER}.sha256" &> /dev/null

openssl dgst -sha256 -binary "${ISSUER}" > "${ISSUER}.sha256"

HEX="$(cat "${ISSUER}.sha256" | xxd -p -c 64)"

. $mt/checks/eq.sh 64 "${#HEX}" "Hash \"${ISSUER}\" error!"
