#!/usr/local/bin/bash

ISSUER=".mt/gh-commit.json"
. $mt/checks/file "${ISSUER}"

RESULT_COMMIT="$(yq -erM .sha "${ISSUER}")" || exit 1

. $mt/checks/require REPOSITORY_OWNER REPOSITORY_NAME SOURCE_COMMIT TARGET_COMMIT RESULT_COMMIT

OWNER_URL="https://github.com/${REPOSITORY_OWNER}"
REP_URL="https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}"
MESSAGE="
[${REPOSITORY_OWNER}](${OWNER_URL}) / [${REPOSITORY_NAME}](${REP_URL})

\`*\` [${RESULT_COMMIT::7}](${REP_URL}/commit/${RESULT_COMMIT})
\`|\\\`
\`| *\` [${SOURCE_COMMIT::7}](${REP_URL}/commit/${SOURCE_COMMIT})
\`*\` [${TARGET_COMMIT::7}](${REP_URL}/commit/${TARGET_COMMIT})
"

. $mt/tg/message.sh "${MESSAGE}"
