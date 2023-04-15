#!/bin/sh

TEST=10

perl -e '$x=localtime(time+('$TEST'*3600));print $x'
