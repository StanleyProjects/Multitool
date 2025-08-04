#!/usr/local/bin/bash

. $mt/vcs/checkout.sh
. $mt/vcs/config.sh
. $mt/vcs/merge.sh
. unstable/assemble.sh
. unstable/commit.sh
. unstable/check.sh
. $mt/vcs/push.sh
