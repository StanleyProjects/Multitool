#!/usr/local/bin/bash

. $mt/checks/eq.sh $# 1 'Wrong arguments!'

COMMIT_TAG="$1"

. $mt/checks/require.sh REPOSITORY_OWNER REPOSITORY_NAME COMMIT_TAG

VCS_API='https://api.github.com'
REP_URL="${VCS_API}/repos/${REPOSITORY_OWNER}/${REPOSITORY_NAME}"
VCS_URL="${REP_URL}/git/ref/tags/${COMMIT_TAG}"

CODE=$(curl -w %{http_code} -o /dev/null "${VCS_URL}")

. $mt/checks/eq.sh "${CODE}" 404 'Tag error!'
