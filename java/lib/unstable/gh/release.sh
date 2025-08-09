#!/usr/local/bin/bash

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file "${ISSUER}"
GROUP_ID="$(yq -erM .repository.groupId "${ISSUER}")" || exit 1
ARTIFACT_ID="$(yq -erM .repository.artifactId "${ISSUER}")" || exit 1

. $mt/checks/eq "${VERSION}" "$(yq -erM .version "${ISSUER}")" 'Version error!'

. $mt/checks/require REPOSITORY_OWNER VERSION GROUP_ID ARTIFACT_ID

PUBLIC_KEY='.mt/public.pem'
curl -f "https://${REPOSITORY_OWNER}.github.io/debug-public.pem" -o "${PUBLIC_KEY}"
. $mt/checks/success $? "Get public key \"${REPOSITORY_OWNER}\" error!"
. $mt/checks/file "${PUBLIC_KEY}"

. $mt/checks/require KEYSTORE KEYSTORE_PASSWORD KEY_ALIAS

ISSUER="lib/build/libs/${ARTIFACT_ID}-${VERSION}.jar"

. $mt/checks/file                  "${ISSUER}"
. $mt/secrets/sign/jar.sh          "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}" "${KEY_ALIAS}"
. $mt/secrets/sign.sh              "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}"
. $mt/secrets/sign/check.sh        "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}"
. $mt/secrets/sign/jar/check.sh    "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}" "${KEY_ALIAS}"
. $mt/secrets/sign/check/public.sh "${ISSUER}" "${PUBLIC_KEY}"
. $mt/secrets/sha256.sh            "${ISSUER}"

MVN_URL='https://central.sonatype.com/repository/maven-snapshots'
MVN_REP="${MVN_URL}/${GROUP_ID//.//}/${ARTIFACT_ID}"

MESSAGE="
[maven-metadata.xml](${MVN_REP}/maven-metadata.xml)
"

. $mt/gh/release.sh "${VERSION}" "${MESSAGE}"

FILE_NAME="${ARTIFACT_ID}-${VERSION}.jar"
ISSUER="lib/build/libs/${FILE_NAME}"

. $mt/gh/release/upload.sh "${VERSION}" "${ISSUER}"        "${FILE_NAME}"
. $mt/gh/release/upload.sh "${VERSION}" "${ISSUER}.sig"    "${FILE_NAME}.sig"
. $mt/gh/release/upload.sh "${VERSION}" "${ISSUER}.sha256" "${FILE_NAME}.sha256"

FILE_NAME="${ARTIFACT_ID}-${VERSION}-sources.jar"
ISSUER="lib/build/libs/${FILE_NAME}"

. $mt/gh/release/upload.sh "${VERSION}" "${ISSUER}" "${FILE_NAME}"
