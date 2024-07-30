#!/bin/bash
# shellcheck disable=2076

export EDITOR=/usr/bin/nvim

export CONFIGURAZIONI="$HOME/Configurazioni"
export CHESS_HOME="$(xdg-user-dir DOCUMENTS)/Scacchi"


#############################
# Path
#############################
declare -a user_path_dirs=(
  "${HOME}/.local/bin" \
  "${HOME}/.local/hacks" \
)

for dir in "${user_path_dirs[@]}"; do
  if ! [[ "${PATH}" =~ "${dir}" ]]; then
    PATH="${dir}:${PATH}"
  fi
done

unset user_path_dirs

export PATH

