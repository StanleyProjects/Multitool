#!/usr/local/bin/bash

. $mt/checks/eq $# 2 'Wrong arguments!'

COMMIT_TAG="$1"
COMMIT_MESSAGE="$2"

. $mt/checks/require COMMIT_TAG COMMIT_MESSAGE

git add . \
 && git commit -S -m "${COMMIT_MESSAGE}" \
 && git tag -s "${COMMIT_TAG}" -m "${COMMIT_MESSAGE}"

. $mt/checks/success $? "Commit \"${COMMIT_TAG}\" error!"
