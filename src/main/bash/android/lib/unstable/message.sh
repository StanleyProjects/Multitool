#!/usr/local/bin/bash

ISSUER=".mt/gh-commit.json"
. $mt/checks/file.sh "${ISSUER}"

RESULT_COMMIT="$(yq -erM .sha "${ISSUER}")" || exit 1

. $mt/checks/require.sh REPOSITORY_OWNER REPOSITORY_NAME SOURCE_COMMIT TARGET_COMMIT RESULT_COMMIT

OWNER_URL="https://github.com/${REPOSITORY_OWNER}"
REP_URL="https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}"

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file.sh "${ISSUER}"
GROUP_ID="$(yq -erM .repository.groupId "${ISSUER}")" || exit 1
ARTIFACT_ID="$(yq -erM .repository.artifactId "${ISSUER}")" || exit 1

MVN_URL='https://central.sonatype.com/repository/maven-snapshots'
MVN_REP="${MVN_URL}/${GROUP_ID//.//}/${ARTIFACT_ID}"

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file.sh "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

RELEASE_FILE=".mt/gh-${VERSION}-release.json"
. $mt/checks/file.sh "${RELEASE_FILE}"
RELEASE_URL="$(yq -erM .html_url "${RELEASE_FILE}")" || exit 1

MESSAGE="[${REPOSITORY_OWNER}](${OWNER_URL}) / [${REPOSITORY_NAME}](${REP_URL})"

MESSAGE+=$'\n'
MESSAGE+="
\`*\` [${RESULT_COMMIT::7}](${REP_URL}/commit/${RESULT_COMMIT})
\`|\\\`
\`| *\` [${SOURCE_COMMIT::7}](${REP_URL}/commit/${SOURCE_COMMIT})
\`*\` [${TARGET_COMMIT::7}](${REP_URL}/commit/${TARGET_COMMIT})
"

ISSUER_NAME="${ARTIFACT_ID}-${VERSION}.aar"
ISSUER="lib/build/outputs/aar/${ISSUER_NAME}"

. $mt/checks/file.sh "${ISSUER}"

MESSAGE+=$'\n'
MESSAGE+="\`${VERSION}\`"

MESSAGE+=" / "
MESSAGE+="[Release](${RELEASE_URL})"

MESSAGE+=" / "
MESSAGE+="[Changes](${REP_URL}/compare/${TARGET_COMMIT}...${RESULT_COMMIT})"

MESSAGE+=" / "
MESSAGE+="[Maven](${MVN_REP}/maven-metadata.xml)"

MESSAGE+=" / "
MESSAGE+="[Artifact](${REP_URL}/releases/download/${VERSION}/${ISSUER_NAME})"

. $mt/tg/file.sh "${MESSAGE}" "${ISSUER}"
