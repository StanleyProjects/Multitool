#!/usr/local/bin/bash

. $mt/gh/check/rates.sh

. $mt/gh/checkout.sh
. $mt/gh/config.sh
. $mt/git/merge.sh

echo 'Not implemented!'; exit 1 # todo

. $mt/android/lib/unstable/assemble.sh
. $mt/android/lib/commit.sh
. $mt/android/lib/unstable/check.sh

. $mt/gh/push.sh
. $mt/android/lib/unstable/mvn/deploy.sh
. $mt/android/lib/unstable/gh/release.sh
. $mt/android/lib/unstable/message.sh
