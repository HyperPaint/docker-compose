#!/bin/sh

for i in $(seq 1 $1)
do
  mcrcon "execute at @a run summon minecraft:experience_bottle ~ ~3 ~"
done
