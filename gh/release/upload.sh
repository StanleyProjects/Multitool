#!/usr/local/bin/bash

. $mt/checks/eq $# 3 'Wrong arguments!'

RELEASE_VERSION="$1"
FILE_PATH="$2"
FILE_NAME="$3"

UPLOAD_URL="$(yq -erM .upload_url ".mt/gh-${RELEASE_VERSION}-release.json")" || exit 1
UPLOAD_URL="${UPLOAD_URL//\{?name,label\}/}"

. $mt/checks/require REPOSITORY_OWNER REPOSITORY_NAME VCS_PAT RELEASE_VERSION UPLOAD_URL FILE_PATH FILE_NAME

. $mt/checks/file "${FILE_PATH}"

CODE=$(curl -w %{http_code} -o /dev/null \
 -X POST "${UPLOAD_URL}?name=${FILE_NAME}" \
 -H "Authorization: token ${VCS_PAT}" \
 -H 'Content-Type: text/plain' \
 --data-binary "@${FILE_PATH}")

. $mt/checks/eq $CODE 201 "Upload \"${FILE_PATH}\" error!"
