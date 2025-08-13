#!/usr/local/bin/bash

ISSUER='../service/metadata.sh'

METADATA="$($mt/${ISSUER})"
. $mt/../service/assert.sh "${ISSUER}" $? 0

VERSION="$(echo "${METADATA}" | yq -erM .version)" || exit 1
REPO_OWNER="$(echo "${METADATA}" | yq -erM .repository.owner)" || exit 1
REPO_NAME="$(echo "${METADATA}" | yq -erM .repository.name)" || exit 1

EXPECTED_LINE="GitHub [${VERSION}](https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/tag/${VERSION}) release"

EXPECTED_FILE="${mt}/../README.md"
if [[ ! -s "${EXPECTED_FILE}" ]]; then
 echo "File \"${EXPECTED_FILE}\" error!"; exit 1; fi

if [[ "$(cat "${EXPECTED_FILE}")" == *"${EXPECTED_LINE}"* ]]; then
  echo "All checks of the file along the \"${EXPECTED_FILE}\" were successful."
else
  echo "Check \"${EXPECTED_FILE}\" error!"; exit 1; fi
