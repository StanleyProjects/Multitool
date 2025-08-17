#!/usr/local/bin/bash

. $mt/gh/check/rates.sh

. $mt/gh/checkout.sh
. $mt/gh/config.sh
. $mt/git/merge.sh

. $mt/java/lib/snapshot/assemble.sh
. $mt/java/lib/commit.sh
. $mt/java/lib/snapshot/check.sh

. $mt/gh/push.sh
. $mt/java/lib/unstable/mvn/deploy.sh
. $mt/java/lib/unstable/gh/release.sh
. $mt/java/lib/unstable/message.sh
