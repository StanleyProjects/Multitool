#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 3 'Wrong arguments!'

RELEASE_VERSION="$1"
RELEASE_MESSAGE="$2"
PRERELEASE="$3"
DRAFT='false' # todo

. $mt/checks/require.sh REPOSITORY_OWNER REPOSITORY_NAME VCS_PAT RELEASE_VERSION RELEASE_MESSAGE

. $mt/checks/one_of.sh "${PRERELEASE}" 'false' 'true'

VCS_API='https://api.github.com'
REP_URL="${VCS_API}/repos/${REPOSITORY_OWNER}/${REPOSITORY_NAME}"
VCS_URL="${REP_URL}/releases/tags/${RELEASE_VERSION}"
CODE="$(curl -s -w %{http_code} -o /dev/null "${VCS_URL}")"
. $mt/checks/ne.sh $CODE 200 "Release \"${RELEASE_VERSION}\" exists!"
. $mt/checks/eq.sh $CODE 404 "Deploy \"${RELEASE_VERSION}\" error!"

VCS_URL="${REP_URL}/git/ref/tags/${RELEASE_VERSION}"
ISSUER=".mt/gh-${RELEASE_VERSION}-tag.json"
curl -f "${VCS_URL}?salt=${RANDOM}" -o "${ISSUER}"
. $mt/checks/success.sh $? "Get tag \"${RELEASE_VERSION}\" error!"
. $mt/checks/file.sh "${ISSUER}"

TAG_TYPE="$(yq -erM .object.type "${ISSUER}")" || exit 1
. $mt/checks/eq.sh "${TAG_TYPE}" 'tag' 'Tag type error!'

TAG_SHA="$(yq -erM .object.sha "${ISSUER}")" || exit 1
. $mt/checks/filled.sh "${TAG_SHA}" 'Tag SHA is empty!'

VCS_URL="${REP_URL}/git/tags/${TAG_SHA}"
ISSUER=".mt/gh-${RELEASE_VERSION}-tag.json"
curl -f "${VCS_URL}" -o "${ISSUER}"
. $mt/checks/success.sh $? "Get tag \"${TAG_SHA}\" error!"
. $mt/checks/file.sh "${ISSUER}"

TAG_VERIFIED="$(yq -erM .verification.verified "${ISSUER}")" || exit 1
. $mt/checks/eq.sh "${TAG_VERIFIED}" 'true' 'Tag verification error!'

COMMIT_SHA="$(yq -erM .object.sha "${ISSUER}")" || exit 1
. $mt/checks/filled.sh "${COMMIT_SHA}" 'Commit SHA is empty!'

REQUEST_BODY='{}'
for it in \
  ".draft=${DRAFT}" \
  ".prerelease=${PRERELEASE}" \
  ".name=\"${RELEASE_VERSION}\"" \
  ".tag_name=\"${RELEASE_VERSION}\"" \
  ".target_commitish=\"${COMMIT_SHA}\"" \
  ".body=\"${RELEASE_MESSAGE}\""; do
 REQUEST_BODY="$(echo "${REQUEST_BODY}" | yq -M -o=json "${it}")"
 . $mt/checks/success.sh $? 'Request body error!'
done

VCS_URL="${REP_URL}/releases"
ISSUER=".mt/gh-${RELEASE_VERSION}-release.json"
CODE="$(curl -s -w %{http_code} -X POST "${VCS_URL}" \
 -H "Authorization: token ${VCS_PAT}" \
 -d "${REQUEST_BODY}" \
 -o "${ISSUER}")"

. $mt/checks/eq.sh "${CODE}" 201 "Release \"${RELEASE_VERSION}\" error!"

. $mt/checks/file.sh "${ISSUER}"

echo "https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}/releases/tag/${RELEASE_VERSION}"
