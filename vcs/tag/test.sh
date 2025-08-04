#!/usr/local/bin/bash

. $mt/checks/eq $# 1 'Wrong arguments!'

COMMIT_TAG="$1"

. $mt/checks/require REPOSITORY_OWNER REPOSITORY_NAME COMMIT_TAG

VCS_API='https://api.github.com'

CODE=$(curl -w %{http_code} -o /dev/null "${VCS_API}/repos/${REPOSITORY_OWNER}/${REPOSITORY_NAME}/git/ref/tags/${COMMIT_TAG}")

. $mt/checks/eq $CODE 404 'Tag error!'
