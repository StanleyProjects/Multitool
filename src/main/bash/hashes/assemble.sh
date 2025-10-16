#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 2 'Wrong arguments!'

SRC_NAME="$1"
DST_NAME="$2"

. $mt/checks/filled.sh "${SRC_NAME}" 'No src name!'
. $mt/checks/filled.sh "${DST_NAME}" 'No dst name!'

. $mt/checks/file.sh "${SRC_NAME}"

. $mt/hashes/md5.sh "${SRC_NAME}"
. $mt/hashes/sha1.sh "${SRC_NAME}"
. $mt/hashes/sha256.sh "${SRC_NAME}"
. $mt/hashes/sha512.sh "${SRC_NAME}"

rm "${DST_NAME}" &> /dev/null

echo "md5:    $(cat "${SRC_NAME}.md5"    | xxd -p -c 64 )" >> "${DST_NAME}"
echo "sha1:   $(cat "${SRC_NAME}.sha1"   | xxd -p -c 64 )" >> "${DST_NAME}"
echo "sha256: $(cat "${SRC_NAME}.sha256" | xxd -p -c 64 )" >> "${DST_NAME}"
echo "sha512: $(cat "${SRC_NAME}.sha512" | xxd -p -c 128)" >> "${DST_NAME}"
