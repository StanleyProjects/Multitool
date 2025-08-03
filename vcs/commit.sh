#!/usr/local/bin/bash

. checks/eq $# 2 'Wrong arguments!'

COMMIT_MESSAGE="$1"
COMMIT_TAG="$2"

. checks/require COMMIT_MESSAGE COMMIT_TAG

git add . \
 && git commit -m "${COMMIT_MESSAGE}" \
 && git tag "${COMMIT_TAG}"

. checks/success $? "Commit \"${COMMIT_TAG}\" error!"
