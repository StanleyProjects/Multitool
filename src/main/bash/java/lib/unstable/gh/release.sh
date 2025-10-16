#!/usr/local/bin/bash

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file.sh "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file.sh "${ISSUER}"
GROUP_ID="$(yq -erM .repository.groupId "${ISSUER}")" || exit 1
ARTIFACT_ID="$(yq -erM .repository.artifactId "${ISSUER}")" || exit 1

ISSUER=".mt/gh-commit.json"
. $mt/checks/file.sh "${ISSUER}"

RESULT_COMMIT="$(yq -erM .sha "${ISSUER}")" || exit 1

. $mt/checks/require.sh REPOSITORY_OWNER REPOSITORY_NAME VERSION GROUP_ID ARTIFACT_ID TARGET_COMMIT RESULT_COMMIT

PUBLIC_KEY='.mt/public.pem'
curl -f "https://${REPOSITORY_OWNER}.github.io/debug-public.pem" -o "${PUBLIC_KEY}"
. $mt/checks/success.sh $? "Get public key \"${REPOSITORY_OWNER}\" error!"
. $mt/checks/file.sh "${PUBLIC_KEY}"

. $mt/checks/require.sh KEYSTORE KEYSTORE_PASSWORD KEY_ALIAS

ISSUER="lib/build/libs/${ARTIFACT_ID}-${VERSION}.jar"

. $mt/checks/file.sh               "${ISSUER}"
. $mt/secrets/sign/jar.sh          "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}" "${KEY_ALIAS}"
. $mt/secrets/sign.sh              "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}"
. $mt/secrets/sign/jar/check.sh    "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}" "${KEY_ALIAS}"
. $mt/secrets/sign/check.sh        "${ISSUER}" "${KEYSTORE}" "${KEYSTORE_PASSWORD}"
. $mt/secrets/sign/check/public.sh "${ISSUER}" "${PUBLIC_KEY}"
. $mt/hashes/sha256.sh             "${ISSUER}"

MVN_URL='https://central.sonatype.com/repository/maven-snapshots'
MVN_REP="${MVN_URL}/${GROUP_ID//.//}/${ARTIFACT_ID}"

REP_URL="https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}"

MESSAGE="
[Changes](${REP_URL}/compare/${TARGET_COMMIT}...${RESULT_COMMIT}) from [${TARGET_COMMIT::7}](${REP_URL}/commit/${TARGET_COMMIT}) to [${RESULT_COMMIT::7}](${REP_URL}/commit/${RESULT_COMMIT})

Maven [metadata.xml](${MVN_REP}/maven-metadata.xml)
"

. $mt/gh/release.sh "${VERSION}" "${MESSAGE}" 'true'

ISSUER_NAME="${ARTIFACT_ID}-${VERSION}.jar"
ISSUER="lib/build/libs/${ISSUER_NAME}"

. $mt/gh/release/upload.sh "${VERSION}" "${ISSUER}"        "${ISSUER_NAME}"
. $mt/gh/release/upload.sh "${VERSION}" "${ISSUER}.sig"    "${ISSUER_NAME}.sig"
. $mt/gh/release/upload.sh "${VERSION}" "${ISSUER}.sha256" "${ISSUER_NAME}.sha256"

ISSUER_NAME="${ARTIFACT_ID}-${VERSION}-sources.jar"
ISSUER="lib/build/libs/${ISSUER_NAME}"

. $mt/gh/release/upload.sh "${VERSION}" "${ISSUER}" "${ISSUER_NAME}"
