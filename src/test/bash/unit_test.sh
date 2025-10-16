#!/usr/local/bin/bash

tests='src/test/bash'
asserts="${tests}/asserts"
mt='src/main/bash'

. $tests/checks/eq_test.sh
. $tests/checks/file_test.sh
. $tests/checks/filled_test.sh
. $tests/checks/gt_test.sh
. $tests/checks/lt_test.sh
. $tests/checks/ne_test.sh
. $tests/checks/one_of_test.sh
. $tests/hashes/md5_test.sh
. $tests/hashes/sha1_test.sh
. $tests/hashes/sha256_test.sh
. $tests/hashes/sha512_test.sh

. $tests/readme_test.sh
. $tests/license_test.sh

echo 'All tests were successful.'
