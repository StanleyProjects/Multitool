#!/usr/local/bin/bash

ISSUER='build/yml/metadata.yml'
. $mt/checks/file.sh "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1
REP_OWNER="$(yq -erM .repository.owner "${ISSUER}")" || exit 1
REP_NAME="$(yq -erM .repository.name "${ISSUER}")" || exit 1

ISSUER=".mt/gh-commit.json"
. $mt/checks/file.sh "${ISSUER}"

RESULT_COMMIT="$(yq -erM .sha "${ISSUER}")" || exit 1

. $mt/checks/require.sh REP_OWNER REP_NAME VERSION TARGET_COMMIT RESULT_COMMIT

PUBLIC_KEY='.mt/public.pem'
curl -f "https://${REP_OWNER}.github.io/debug-public.pem" -o "${PUBLIC_KEY}"
. $mt/checks/success.sh $? "Get public key \"${REP_OWNER}\" error!"
. $mt/checks/file.sh "${PUBLIC_KEY}"

. $mt/checks/require.sh KEYSTORE KEYSTORE_PASSWORD KEY_ALIAS

ISSUER="build/zip/${REP_NAME}-${VERSION}.zip"

. $mt/checks/file.sh               "${ISSUER}"
. $mt/secrets/sign.sh              "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}"
. $mt/secrets/sign/check.sh        "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}"
. $mt/secrets/sign/check/public.sh "${ISSUER}" "${PUBLIC_KEY}"
. $mt/hashes/sha256.sh             "${ISSUER}"

REP_URL="https://github.com/${REP_OWNER}/${REP_NAME}"

MESSAGE="
[Changes](${REP_URL}/compare/${TARGET_COMMIT}...${RESULT_COMMIT}) from [${TARGET_COMMIT::7}](${REP_URL}/commit/${TARGET_COMMIT}) to [${RESULT_COMMIT::7}](${REP_URL}/commit/${RESULT_COMMIT})

sha256: \`$(cat "${ISSUER}.sha256" | xxd -p -c 64)\`
"

. $mt/gh/release.sh "${VERSION}" "${MESSAGE}" 'false'

ISSUER_NAME="${REP_NAME}-${VERSION}.zip"
ISSUER="build/zip/${ISSUER_NAME}"

. $mt/gh/release/upload.sh "${VERSION}" "${ISSUER}"        "${ISSUER_NAME}"
. $mt/gh/release/upload.sh "${VERSION}" "${ISSUER}.sig"    "${ISSUER_NAME}.sig"
. $mt/gh/release/upload.sh "${VERSION}" "${ISSUER}.sha256" "${ISSUER_NAME}.sha256"
