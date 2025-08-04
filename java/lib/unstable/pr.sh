#!/usr/local/bin/bash

. $mt/vcs/checkout.sh
. $mt/vcs/config.sh
. $mt/vcs/merge.sh
. $mt/java/lib/unstable/assemble.sh
. $mt/java/lib/unstable/commit.sh
. $mt/java/lib/unstable/check.sh
. $mt/vcs/push.sh
