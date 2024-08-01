#!/bin/bash
# shellcheck disable=2076

##############################
# XDG Directories
##############################
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

##############################
# Global environment variables
##############################
export EDITOR=/usr/bin/nvim

# The path to my scripts directory
# My scripts may use this variable to access libraries inside this folder
export HACKS_BIN="$HOME/.local/hacks"

##############################
# Ensure this directories are in the PATH
# Prepend to the PATH
##############################
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
