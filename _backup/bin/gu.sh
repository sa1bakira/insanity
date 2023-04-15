#!/bin/sh

cp -v /home/panku/bin/* /home/panku/websites/insanity/_backup/bin

git -C /home/panku/websites/insanity status
git -C /home/panku/websites/insanity add -A
git -C /home/panku/websites/insanity commit -m "backup"
git -C /home/panku/websites/insanity push
