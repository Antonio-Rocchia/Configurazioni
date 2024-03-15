#!/bin/bash

declare -a user_path_dirs=(
  "${HOME}/.local/bin" \
  "${HOME}/.local/bin/config_managed"
)

for dir in "${user_path_dirs[@]}"; do
  if ! [[ "${PATH}" =~ "${dir}" ]]; then
    PATH="${dir}:${PATH}"
  fi
done

unset user_path_dirs

export PATH

