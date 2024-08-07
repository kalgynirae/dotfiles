#!/bin/bash

for suffix in "" "-Italic"; do
  pipenv run pyftfeatfreeze -v -R 'Inter/Interkalgy' -f cv05,cv08 fonts/InterVariable"$suffix".ttf ~/.local/share/fonts/InterkalgyVariable"$suffix".ttf
done
