#!/usr/local/bin/bash

VCS_API='https://api.github.com'
VCS_URL="${VCS_API}/rate_limit"
ISSUER=".mt/gh-limits.json"
CODE="$(curl -s -w %{http_code} -o "${ISSUER}" "${VCS_URL}")"
. $mt/checks/eq.sh $CODE 200 "Get limits error!"
. $mt/checks/file.sh "${ISSUER}"

REMAINING="$(yq -erM .rate.remaining "${ISSUER}")" || exit 1

. $mt/checks/gt.sh "${REMAINING}" 20 "Remaining ${REMAINING}!"
