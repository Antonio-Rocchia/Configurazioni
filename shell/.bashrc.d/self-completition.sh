#!/bin/bash
#
# Enable command completition for various scripts
shopt -s globstar nullglob

declare script

for file in "${HOME}"/.local/bin/config_managed/**/*; do
  script=$(basename "${file}")
  complete -C "${script}" "${script}"
done

unset script
unset file
