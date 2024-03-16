#!/bin/bash
#
# Enable command completition for various scripts


for f in "${HOME}"/.local/bin/config_managed/*; do
  declare script
  script=$(basename "${f}")
  complete -C "${script}" "${script}"
done

unset script
unset f
