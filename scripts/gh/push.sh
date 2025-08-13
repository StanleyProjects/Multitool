#!/usr/local/bin/bash

git push --follow-tags

. $mt/checks/success $? 'Push error!'

RESULT_COMMIT="$(git rev-parse HEAD)"

. $mt/checks/success $? 'Get commit SHA error!'

ISSUER='.mt/gh-commit.json'
VCS_API='https://api.github.com'
REP_URL="${VCS_API}/repos/${REPOSITORY_OWNER}/${REPOSITORY_NAME}"
VCS_URL="${REP_URL}/commits/${RESULT_COMMIT}"
curl -f "${VCS_URL}" -o "${ISSUER}"
. $mt/checks/success $? "Get commit ${RESULT_COMMIT} error!"
. $mt/checks/file "${ISSUER}"
