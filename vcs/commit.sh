#!/usr/local/bin/bash

. $mt/checks/eq $# 2 'Wrong arguments!'

COMMIT_MESSAGE="$1"
COMMIT_TAG="$2"

. $mt/checks/require COMMIT_MESSAGE COMMIT_TAG

git add . \
 && git commit -S -m "${COMMIT_MESSAGE}" \
 && git tag -s "${COMMIT_TAG}" -m "${COMMIT_TAG}"

. $mt/checks/success $? "Commit \"${COMMIT_TAG}\" error!"
