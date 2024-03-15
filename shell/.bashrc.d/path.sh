#!/bin/bash

_add_usr_dirs_to_path() {
  declare -ar user_path_dirs=(
    "${HOME}/.local/bin/config_managed" \
  )
  for dir in "${user_path_dirs[@]}"; do
    if ! [[ "${PATH}" =~ "${dir}" ]]; then
      PATH="${dir}:${PATH}"
    fi
  done

  export PATH
}

_add_usr_dirs_to_path
