#!/usr/local/bin/bash

tests='src/test/bash'
asserts="${tests}/asserts"
mt='src/main/bash'

# todo
. $tests/readme_test.sh
. $tests/license_test.sh

echo 'All tests were successful.'
