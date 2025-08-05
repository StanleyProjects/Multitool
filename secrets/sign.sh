#!/usr/local/bin/bash

. $mt/checks/eq $# 3 'Wrong arguments!'

KEYSTORE_TYPE='pkcs12'
ISSUER="$1"
KEYSTORE="$2"
KEYSTORE_PASSWORD="$3"

. $mt/checks/require ISSUER KEYSTORE KEYSTORE_PASSWORD KEYSTORE_TYPE

. $mt/checks/file "${KEYSTORE}"

openssl pkcs12 -in "${KEYSTORE}" -nokeys -passin "pass:${KEYSTORE_PASSWORD}" | openssl x509 -checkend 0

. $mt/checks/success $? "Check \"${KEYSTORE}\" error!"

. $mt/checks/file "${ISSUER}"

rm "${ISSUER}.sig"

openssl dgst -sha512 -sign <(
  openssl "${KEYSTORE_TYPE}" -in "${KEYSTORE}" -nocerts \
   -passin "pass:${KEYSTORE_PASSWORD}" \
   -passout "pass:${KEYSTORE_PASSWORD}" \
 ) -passin "pass:${KEYSTORE_PASSWORD}" -out "${ISSUER}.sig" "${ISSUER}"

. $mt/checks/success $? "Sign \"${ISSUER}\" error!"

. $mt/checks/file "${ISSUER}.sig"
