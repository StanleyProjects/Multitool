#!/usr/local/bin/bash

. $mt/checks/eq $# 2 'Wrong arguments!'

RELEASE_VERSION="$1"
RELEASE_MESSAGE="$2"

. $mt/checks/require REPOSITORY_OWNER REPOSITORY_NAME VCS_PAT RELEASE_VERSION RELEASE_MESSAGE

VCS_API='https://api.github.com'
REP_URL="${VCS_API}/repos/${REPOSITORY_OWNER}/${REPOSITORY_NAME}"
VCS_URL="${REP_URL}/releases/tags/${RELEASE_VERSION}"
CODE="$(curl -s -w %{http_code} -o /dev/null "${VCS_URL}")"
. $mt/checks/ne $CODE 200 "Release \"${RELEASE_VERSION}\" exists!"
. $mt/checks/eq $CODE 404 "Deploy \"${RELEASE_VERSION}\" error!"

VCS_URL="${REP_URL}/git/refs/tags/${RELEASE_VERSION}"
ISSUER=".mt/gh-${RELEASE_VERSION}-tag.json"
curl -f "${VCS_URL}" -o "${ISSUER}"
. $mt/checks/success $? "Get tag \"${RELEASE_VERSION}\" error!"
. $mt/checks/file "${ISSUER}"

TAG_SHA="$(yq -erM .object.sha "${ISSUER}")" || exit 1
. $mt/checks/filled "${TAG_SHA}" 'Tag SHA is empty!'

REQUEST_BODY='{draft: false, prerelease: true}'
for it in \
  ".name=\"${RELEASE_VERSION}\"" \
  ".tag_name=\"${RELEASE_VERSION}\"" \
  ".target_commitish=\"${TAG_SHA}\"" \
  ".body=\"${RELEASE_MESSAGE}\""; do
 REQUEST_BODY="$(echo "${REQUEST_BODY}" | yq -M -o=json "${it}")"
 . $mt/checks/success $? 'Request body error!'
done

# todo

VCS_URL="${REP_URL}/releases"
ISSUER=".mt/gh-${RELEASE_VERSION}-release.json"
CODE="$(curl -v -s -w %{http_code} -X POST "${VCS_URL}" \
 -H "Authorization: token ${VCS_PAT}" \
 -d "${REQUEST_BODY}" \
 -o "${ISSUER}")"

if test "${CODE}" != '201'; then
 echo "Release \"${RELEASE_VERSION}\" error!"
 echo "${REQUEST_BODY}" | yq
 cat "${ISSUER}"
 exit 1; fi

# todo

. $mt/checks/file "${ISSUER}"

echo "https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}/releases/tag/${RELEASE_VERSION}"
