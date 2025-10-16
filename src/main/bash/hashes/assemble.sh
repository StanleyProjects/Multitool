#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 1 'Wrong arguments!'

ISSUER="$1"

. $mt/checks/filled.sh "${ISSUER}" 'No file name!'

. $mt/checks/file.sh "${ISSUER}"

. $mt/checks/file.sh "${ISSUER}.md5"
. $mt/checks/file.sh "${ISSUER}.sha1"
. $mt/checks/file.sh "${ISSUER}.sha256"
. $mt/checks/file.sh "${ISSUER}.sha512"

rm "${ISSUER}-hashes.txt" &> /dev/null

echo "md5:    $(cat "${ISSUER}.md5"    | xxd -p -c 64 )" >> "${ISSUER}-hashes.txt"
echo "sha1:   $(cat "${ISSUER}.sha1"   | xxd -p -c 64 )" >> "${ISSUER}-hashes.txt"
echo "sha256: $(cat "${ISSUER}.sha256" | xxd -p -c 64 )" >> "${ISSUER}-hashes.txt"
echo "sha512: $(cat "${ISSUER}.sha512" | xxd -p -c 128)" >> "${ISSUER}-hashes.txt"
