#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 1 'Wrong arguments!'

ISSUER="$1"

. $mt/checks/filled.sh "${ISSUER}" 'No file name!'

. $mt/checks/file.sh "${ISSUER}"

rm "${ISSUER}.md5" &> /dev/null

HASH="$(openssl dgst -md5 -binary "${ISSUER}" | xxd -p -c 64)"

. $mt/checks/eq.sh 32 "${#HASH}" "Hash \"${ISSUER}\" error!"

echo "${HASH}" > "${ISSUER}.md5"

. $mt/checks/file.sh "${ISSUER}.md5"
