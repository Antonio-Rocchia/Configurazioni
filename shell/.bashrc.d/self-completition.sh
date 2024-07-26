#!/bin/bash
#
# Enable command completition for various scripts

declare script

for file in "${HOME}"/.local/hacks/*; do
  script=$(basename "${file}")
  complete -o filenames -C "${script}" "${script}"
done

unset script
unset file
