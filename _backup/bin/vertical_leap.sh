#!/bin/sh

tr -dc A-Za-z0-9 </dev/urandom | head -c 165 ; echo ''
