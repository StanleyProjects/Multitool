#!/usr/local/bin/bash

. $mt/gh/checkout.sh
. $mt/gh/config.sh
. $mt/vcs/merge.sh
. $mt/java/lib/snapshot/assemble.sh
. $mt/java/lib/unstable/commit.sh
. $mt/java/lib/snapshot/check.sh
. $mt/gh/push.sh
. $mt/java/lib/unstable/mvn/snapshot/deploy.sh
. $mt/java/lib/unstable/gh/release.sh
. $mt/java/lib/unstable/message.sh
