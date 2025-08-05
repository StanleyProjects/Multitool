#!/usr/local/bin/bash

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file "${ISSUER}"
ARTIFACT_ID="$(yq -erM .repository.artifactId "${ISSUER}")" || exit 1

. $mt/checks/eq "${VERSION}" "$(yq -erM .version "${ISSUER}")" 'Version error!'

. $mt/checks/require VERSION ARTIFACT_ID

PUBLIC_KEY='.mt/public.pem'
curl -f "https://${REPOSITORY_OWNER}.github.io/debug-public.pem" -o "${PUBLIC_KEY}"
. $mt/checks/success $? "Get public key \"${REPOSITORY_OWNER}\" error!"
. $mt/checks/file "${PUBLIC_KEY}"

ISSUER="lib/build/libs/${ARTIFACT_ID}-${VERSION}.jar"
. $mt/checks/file "${ISSUER}"

. $mt/checks/require KEYSTORE KEYSTORE_PASSWORD KEY_ALIAS

. $mt/secrets/sign/jar.sh          "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}" "${KEY_ALIAS}"
. $mt/secrets/sign.sh              "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}"

. $mt/secrets/sign/check.sh        "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}"
. $mt/secrets/sign/jar/check.sh    "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}" "${KEY_ALIAS}"
. $mt/secrets/sign/check/public.sh "${ISSUER}" "${PUBLIC_KEY}"

MESSAGE="
There should be files here...
" # todo

. $mt/gh/release.sh "${VERSION}" "${MESSAGE}"

. $mt/gh/release/upload.sh "${VERSION}" "lib/build/libs/${ARTIFACT_ID}-${VERSION}.jar"     "${ARTIFACT_ID}-${VERSION}.jar"
. $mt/gh/release/upload.sh "${VERSION}" "lib/build/libs/${ARTIFACT_ID}-${VERSION}.jar.sig" "${ARTIFACT_ID}-${VERSION}.jar.sig"
