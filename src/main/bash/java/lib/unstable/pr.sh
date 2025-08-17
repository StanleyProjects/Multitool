#!/usr/local/bin/bash

. $mt/gh/checkout.sh
. $mt/gh/config.sh
. $mt/git/merge.sh

. $mt/java/lib/unstable/assemble.sh
. $mt/java/lib/commit.sh
. $mt/java/lib/unstable/check.sh

echo 'Not implemented!'; exit 1 # todo

. $mt/gh/push.sh
. $mt/java/lib/unstable/mvn/deploy.sh
. $mt/java/lib/unstable/gh/release.sh
. $mt/java/lib/unstable/message.sh
