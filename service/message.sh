#!/usr/local/bin/bash

ISSUER=".mt/gh-commit.json"
. $mt/checks/file "${ISSUER}"

RESULT_COMMIT="$(yq -erM .sha "${ISSUER}")" || exit 1

ISSUER='.mt/metadata.yml'
. $mt/checks/file "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1
REP_OWNER="$(yq -erM .repository.owner "${ISSUER}")" || exit 1
REP_NAME="$(yq -erM .repository.name "${ISSUER}")" || exit 1

RELEASE_FILE=".mt/gh-${VERSION}-release.json"
. $mt/checks/file "${RELEASE_FILE}"
RELEASE_URL="$(yq -erM .html_url "${RELEASE_FILE}")" || exit 1

OWNER_URL="https://github.com/${REP_OWNER}"
REP_URL="https://github.com/${REP_OWNER}/${REP_NAME}"

MESSAGE="[${REP_OWNER}](${OWNER_URL}) / [${REP_NAME}](${REP_URL})"

MESSAGE+=$'\n'
MESSAGE+="
\`*\` [${RESULT_COMMIT::7}](${REP_URL}/commit/${RESULT_COMMIT})
\`|\\\`
\`| *\` [${SOURCE_COMMIT::7}](${REP_URL}/commit/${SOURCE_COMMIT})
\`*\` [${TARGET_COMMIT::7}](${REP_URL}/commit/${TARGET_COMMIT})
"

MESSAGE+=$'\n'
MESSAGE+="\`${VERSION}\`"

MESSAGE+=" / "
MESSAGE+="[Release](${RELEASE_URL})"

MESSAGE+=" / "
MESSAGE+="[Changes](${REP_URL}/compare/${TARGET_COMMIT}...${RESULT_COMMIT})"

MESSAGE+=" / "
MESSAGE+="[Artifact](${REP_URL}/releases/download/${VERSION}/${REP_NAME}-${VERSION}.zip)"

ISSUER=".mt/${REP_NAME}-${VERSION}.zip"
. $mt/checks/file "${ISSUER}"

. $mt/tg/file.sh "${MESSAGE}" "${ISSUER}"
