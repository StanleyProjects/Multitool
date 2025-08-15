#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 4 'Wrong arguments!'

KEYSTORE_TYPE='pkcs12'
ISSUER="$1"
KEYSTORE="$2"
KEYSTORE_PASSWORD="$3"
KEY_ALIAS="$4"

. $mt/checks/require.sh ISSUER KEYSTORE KEYSTORE_PASSWORD KEY_ALIAS

. $mt/checks/file.sh "${KEYSTORE}"

openssl "${KEYSTORE_TYPE}" -in "${KEYSTORE}" -nokeys -passin "pass:${KEYSTORE_PASSWORD}" | openssl x509 -checkend 0

. $mt/checks/success.sh $? "Check \"${KEYSTORE}\" error!"

. $mt/checks/file.sh "${ISSUER}"

jarsigner -verify "${ISSUER}" &> /dev/null

. $mt/checks/success.sh $? "Check signature of \"${ISSUER}\" error!"

SIGNATURE="$(unzip -p "${ISSUER}" "META-INF/${KEY_ALIAS^^}.SF")"

. $mt/checks/success.sh $? "Get signature of \"${ISSUER}\" error!"

SIGNER="$(openssl "${KEYSTORE_TYPE}" -in "${KEYSTORE}" -nokeys -nodes -passin "pass:${KEYSTORE_PASSWORD}")"

. $mt/checks/success.sh $? "Get signer of \"${KEYSTORE}\" error!"

KEY="$(openssl "${KEYSTORE_TYPE}" -in "${KEYSTORE}" -nocerts -nodes -passin "pass:${KEYSTORE_PASSWORD}")"

. $mt/checks/success.sh $? "Get key of \"${KEYSTORE}\" error!"

. $mt/checks/require.sh SIGNATURE SIGNER KEY

openssl cms -verify -noverify -content <(echo "${SIGNATURE}") -inform DER \
 -in <(openssl cms -sign -binary -noattr -outform DER \
  -signer <(echo "${SIGNER}") -inkey <(echo "${KEY}") -md sha256 -in <(echo "${SIGNATURE}")) &> /dev/null

. $mt/checks/success.sh $? "Check expected signature of \"${ISSUER}\" error!"

openssl cms -verify -noverify -content <(echo "${SIGNATURE}") -inform DER \
 -in <(unzip -p "${ISSUER}" "META-INF/${KEY_ALIAS^^}.RSA") &> /dev/null

. $mt/checks/success.sh $? "Check actual signature of \"${ISSUER}\" error!"
