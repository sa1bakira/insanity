#!/bin/sh

data="one"

data="$data two"

data="$data three"

data="$data $(echo four)"

printf "$data\n\n"
