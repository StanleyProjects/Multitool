#!/usr/local/bin/bash

. $mt/checks/eq $# 4 'Wrong arguments!'

ISSUER="$1"
KEYSTORE="$2"
KEYSTORE_PASSWORD="$3"
KEY_ALIAS="$4"

. $mt/checks/require ISSUER KEYSTORE KEYSTORE_PASSWORD KEY_ALIAS

. $mt/checks/file "${KEYSTORE}"

openssl pkcs12 -in "${KEYSTORE}" -nokeys -passin "pass:${KEYSTORE_PASSWORD}" | openssl x509 -checkend 0

. $mt/checks/success $? "Check \"${KEYSTORE}\" error!"

. $mt/checks/file "${ISSUER}"

RESULT="$(jarsigner -verify "${ISSUER}")"

. $mt/checks/success $? "Check signature of \"${ISSUER}\" error!"

if test "${RESULT//$'\n'/}" != "jar is unsigned."; then
 echo "Jar \"${ISSUER}\" already signed!"; exit 1; fi

jarsigner -keystore "${KEYSTORE}" \
 -keypass "${KEYSTORE_PASSWORD}" -storepass "${KEYSTORE_PASSWORD}" \
 -sigalg SHA512withRSA -digestalg SHA-512 \
 "${ISSUER}" "${KEY_ALIAS}"

. $mt/checks/success $? "Sign jar \"${ISSUER}\" error!"
