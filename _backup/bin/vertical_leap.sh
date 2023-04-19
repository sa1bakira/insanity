#!/bin/sh


cat /dev/random

#while :; do
    tr -dc A-Za-z0-9 </dev/urandom | head -c 160; echo ''
#done
