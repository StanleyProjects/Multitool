#!/usr/local/bin/bash

gradle 'checkLicense'

. $mt/checks/success $? 'Check error!'
