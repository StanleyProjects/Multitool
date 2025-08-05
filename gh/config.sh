#!/usr/local/bin/bash

. $mt/checks/require VCS_PAT

VCS_API='https://api.github.com'

ISSUER='.mt/gh-user.json'
curl -f "${VCS_API}/user" -H "Authorization: token ${VCS_PAT}" -o "${ISSUER}"
. $mt/checks/success $? 'Get user error!'
. $mt/checks/file "${ISSUER}"

USER_NAME="$(yq -erM .name "${ISSUER}")" || exit 1
USER_ID="$(yq -erM .id "${ISSUER}")" || exit 1
USER_LOGIN="$(yq -erM .login "${ISSUER}")" || exit 1
USER_EMAIL="${USER_ID}+${USER_LOGIN}@users.noreply.github.com"

git config user.name "${USER_NAME}" \
 && git config user.email "${USER_EMAIL}"

. $mt/checks/success $? 'Config error!'
