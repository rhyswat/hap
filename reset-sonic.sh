#!/bin/bash
SONIC=~/.sonic-pi

for x in one two three four five six seven eight
do
  echo -n '' > ${SONIC}/workspaces/default/${x}/1.spi
done

