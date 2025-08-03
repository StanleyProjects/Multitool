#!/usr/local/bin/bash

. checks/require VCS_PAT

VCS_API='https://api.github.com'

GITHUB_USER="$(curl -f "${VCS_API}/user" -H "Authorization: token $VCS_PAT")"
. checks/success $? 'Get user error!'
. checks/filled "$GITHUB_USER" 'User is empty!'

USER_NAME="$(echo "$GITHUB_USER" | yq -erM .name)" || exit 1
USER_ID="$(echo "$GITHUB_USER" | yq -erM .id)" || exit 1
USER_LOGIN="$(echo "$GITHUB_USER" | yq -erM .login)" || exit 1
USER_EMAIL="${USER_ID}+${USER_LOGIN}@users.noreply.github.com"

git config user.name "${USER_NAME}" \
 && git config user.email "${USER_EMAIL}"

. checks/success $? 'Config error!'
