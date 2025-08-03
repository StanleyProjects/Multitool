#!/usr/local/bin/bash

gradle 'checkLicense'

. checks/success $? 'Check error!'
