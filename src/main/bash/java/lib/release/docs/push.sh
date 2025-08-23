#!/usr/local/bin/bash

. $mt/checks/require.sh REPOSITORY_OWNER REPOSITORY_NAME VCS_PAT

VARIANT='release'

ISSUER='lib/build/yml/metadata.yml'
. $mt/checks/file.sh "${ISSUER}"
VERSION="$(yq -erM .version "${ISSUER}")" || exit 1

COMMIT_MESSAGE="docs:${VERSION}"
COMMIT_TAG="docs/${VERSION}"

. $mt/gh/tag/test.sh "${COMMIT_TAG}"

ISSUER="lib/build/docs/${VARIANT}/index.html"
. $mt/checks/file.sh "${ISSUER}"

DOCS_PATH='.mt/docs'
mkdir "${DOCS_PATH}"

VCS_URL="https://${VCS_PAT}@github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME}.git"

git -C "${DOCS_PATH}" init \
 && git -C "${DOCS_PATH}" remote add origin "${VCS_URL}"

. $mt/checks/success.sh $? 'Init docs error!'

ISSUER='.mt/gh-gpg-keys.json'
. $mt/checks/file.sh "${ISSUER}"
GPG_KEY_ID="$(yq -erM .[0].key_id "${ISSUER}")" || exit 1

ISSUER='.mt/gh-user.json'
. $mt/checks/file.sh "${ISSUER}"

USER_NAME="$(yq -erM .name "${ISSUER}")" || exit 1
USER_ID="$(yq -erM .id "${ISSUER}")" || exit 1
USER_LOGIN="$(yq -erM .login "${ISSUER}")" || exit 1
USER_EMAIL="${USER_ID}+${USER_LOGIN}@users.noreply.github.com"

git -C "${DOCS_PATH}" config user.name "${USER_NAME}" \
 && git -C "${DOCS_PATH}" config user.email "${USER_EMAIL}" \
 && git -C "${DOCS_PATH}" config gpg.program '/usr/local/bin/gpgloopback.sh' \
 && git -C "${DOCS_PATH}" config user.signingkey "${GPG_KEY_ID}"

. $mt/checks/success.sh $? 'Config docs error!'

BRANCH_NAME='gh-pages'
VCS_API='https://api.github.com'
REP_URL="${VCS_API}/repos/${REPOSITORY_OWNER}/${REPOSITORY_NAME}"
VCS_URL="${REP_URL}/branches/${BRANCH_NAME}"
ISSUER='.mt/gh-branch-pages.json'
CODE="$(curl -s -w %{http_code} -o "${ISSUER}" "${VCS_URL}")"
if [ "${CODE}" == 200 ]; then
 git -C "${DOCS_PATH}" fetch --depth=1 origin "${BRANCH_NAME}" \
  && git -C "${DOCS_PATH}" checkout "${BRANCH_NAME}"
 . $mt/checks/success.sh $? 'Checkout pages error!'
elif [ "${CODE}" == 404 ]; then
 git -C "${DOCS_PATH}" checkout --orphan "${BRANCH_NAME}"
 . $mt/checks/success.sh $? "Checkout ${BRANCH_NAME} error!"
 echo "${REPOSITORY_NAME}" > "${DOCS_PATH}/index.html" \
  && git -C "${DOCS_PATH}" add . \
  && git -C "${DOCS_PATH}" commit -m 'init pages'
 . $mt/checks/success.sh $? 'Commit pages error!'
 git -C "${DOCS_PATH}" push -u origin "${BRANCH_NAME}"
 . $mt/checks/success.sh $? "Push ${BRANCH_NAME} error!"
else
 echo "Get branch ${BRANCH_NAME} error!"; exit 1; fi

if [[ -f "${DOCS_PATH}/docs/${VERSION}/index.html" ]]; then
 echo 'Docs version error!'; exit 1; fi

mkdir "${DOCS_PATH}/docs"
cp -r "lib/build/docs/${VARIANT}" "${DOCS_PATH}/docs/${VERSION}"

. $mt/checks/success.sh $? 'Copy docs error!'

git -C "${DOCS_PATH}" add . \
 && git -C "${DOCS_PATH}" commit -S -m "${COMMIT_MESSAGE}" \
 && git -C "${DOCS_PATH}" tag -s "${COMMIT_TAG}" -m "${COMMIT_MESSAGE}"

. $mt/checks/success.sh $? 'Commit docs error!'

git -C "${DOCS_PATH}" push --follow-tags

. $mt/checks/success.sh $? 'Push docs error!'

echo "https://${REPOSITORY_OWNER}.github.io/${REPOSITORY_NAME}/docs/${VERSION}"
