#!/usr/local/bin/bash

if test $# -ne 2; then
 echo 'Wrong arguments!'; exit 1; fi

COMMIT_MESSAGE="$1"
COMMIT_TAG="$2"

. checks/require COMMIT_MESSAGE COMMIT_TAG

git add . \
 && git commit -m "${COMMIT_MESSAGE}" \
 && git tag "${COMMIT_TAG}"

. checks/success $? "Commit \"${COMMIT_TAG}\" error!"
