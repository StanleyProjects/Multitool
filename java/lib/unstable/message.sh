#!/usr/local/bin/bash

ISSUER=".mt/gh-commit.json"
. $mt/checks/file "${ISSUER}"

RESULT_COMMIT="$(yq -erM .sha "${ISSUER}")" || exit 1

. $mt/checks/require REPOSITORY_OWNER REPOSITORY_NAME SOURCE_COMMIT TARGET_COMMIT RESULT_COMMIT

OWNER_URL="https://github.com/${REPOSITORY_OWNER}"
REP_URL="https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}"

ISSUER='lib/build/yml/maven-metadata.yml'
. $mt/checks/file "${ISSUER}"
GROUP_ID="$(yq -erM .repository.groupId "${ISSUER}")" || exit 1
ARTIFACT_ID="$(yq -erM .repository.artifactId "${ISSUER}")" || exit 1

MVN_URL='https://central.sonatype.com/repository/maven-snapshots'
MVN_REP="${MVN_URL}/${GROUP_ID//.//}/${ARTIFACT_ID}"

MESSAGE="
[${REPOSITORY_OWNER}](${OWNER_URL}) / [${REPOSITORY_NAME}](${REP_URL})

\`*\` [${RESULT_COMMIT::7}](${REP_URL}/commit/${RESULT_COMMIT})
\`|\\\`
\`| *\` [${SOURCE_COMMIT::7}](${REP_URL}/commit/${SOURCE_COMMIT})
\`*\` [${TARGET_COMMIT::7}](${REP_URL}/commit/${TARGET_COMMIT})

[Maven](${MVN_REP}/maven-metadata.xml)
"

. $mt/tg/message.sh "${MESSAGE}"
