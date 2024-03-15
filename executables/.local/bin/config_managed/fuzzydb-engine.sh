#!/bin/bash
FUZZYDB_DIR="$HOME/.config/fuzzydb"

fuzzydb-engine () {
    ARGC=$#
    MAX_ALLOWED_ARGS=3
    MIN_ALLOWED_ARGS=2
    
    if [[ $ARGC -gt $MAX_ALLOWED_ARGS || $ARGC -lt $MIN_ALLOWED_ARGS ]]; then
      return 2
    fi
    
    OP=$1
    DB_NAME=$2
    STRING=${3-""}

    OLD_DIR=$(pwd)
    mkdir -p "$FUZZYDB_DIR"
    cd "$FUZZYDB_DIR" || return 255
    touch "$DB_NAME"

    case "$OP" in
      save)
          if grep -Fxq "$STRING" "$DB_NAME"; then
            cd "$OLD_DIR" || return 255
            return 1
          else
            echo "$STRING" >> "$DB_NAME"
            cd "$OLD_DIR" || return 255
            return 0
          fi
        ;;
      delete)
        TEMP=$(mktemp)
        DELETE_STRING=$(cat "$DB_NAME" | fzf)
        while IFS= read -r line; do
            if [[ "$line" != "$DELETE_STRING" ]]; then
                echo "$line" >> "$TEMP"
            fi
        done < "$DB_NAME"
        mv "$TEMP" "$DB_NAME"

        cd "$OLD_DIR" || return 255
        return 0
        ;;
      *)
        cd "$OLD_DIR" || return 255
        return 1
        ;;
    esac
}

fuzzydb-usage() {
  PROGRAM_NAME="$1"
  MANAGED_STRING="$2"
  UTILITY="$3"
  echo "Usage: 
  Manage a database of strings ($MANAGED_STRING).
  Perform a fuzzy search in the database by simply invoking the function without providing any arguments.
  Following the search for your specified string, it will be employed to $UTILITY.

  Available commands:

  $1 save <string>  Add a new $MANAGED_STRING to the database.

  $1 delete         Remove a $MANAGED_STRING from the database.

  $1 help           Display this help message.
"
}

quick-locations() {
    PROGRAM_NAME='quick-locations'
    MANAGED_STRING='directory path'
    UTILITY='cd to the selected directory'
    DB_NAME='quick-locations-db'
  
    ARGC=$#
    MAX_ALLOWED_ARGS=2

    if [[ $ARGC -gt $MAX_ALLOWED_ARGS ]]; then
      echo "Error: Too many arguments." >&2
      fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
    elif [[ $ARGC -gt 0 ]]; then
      case $1 in
        save)
          if [[ $ARGC -eq 2 ]]; then
            PATH_TO_ABSOLUTE=$(realpath "$2")
            if ! [[ -d "$PATH_TO_ABSOLUTE" ]]; then
              echo "Error: The arguments for 'save' should be an existent directory's path." >&2
              return 1
            fi
            # ADD TO DATABASE
            fuzzydb-engine 'save' "$DB_NAME" "$PATH_TO_ABSOLUTE"
            SAVE_RESULT=$?
            if [[ "$SAVE_RESULT" -eq 0 ]]; then
              echo "Added $PATH_TO_ABSOLUTE to the $MANAGED_STRING database."
              return 0
            elif [[ "$SAVE_RESULT" -eq 1 ]]; then
              echo "Error: $MANAGED_STRING is already in the database"
              return 1
            else
              echo "Error: Unable to save a $MANAGED_STRING to the database."
              return 1
            fi
          else
            echo "Error: Invalid number of arguments for 'save' command." >&2
            fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        delete)
          if [[ $ARGC -eq 1 ]]; then
            fuzzydb-engine 'delete' "$DB_NAME"
            if [[ $? -ne 0 ]]; then
              echo "Error: Unable to remove a $MANAGED_STRING from the database."
              return 1
            else
              echo "Removed a $MANAGED_STRING from the database."
              return 0
            fi
          else
            echo "Error: Invalid number of arguments for 'delete' command." >&2
            fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        help| --help| -h)
          # Display help message
          fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 0
          ;;
        *)
          echo "Error: Invalid command. Available commands are 'save', 'delete', and 'help'." >&2
          fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 1
          ;;
      esac
    else
      if [[ -f "$FUZZYDB_DIR"/"$DB_NAME" ]]; then
        SELECTED_STRING=$(cat "$FUZZYDB_DIR"/"$DB_NAME" | fzf) 
        if [[ $? -ne 0 ]]; then
          # When the user press escape don't do anything
          return 0
        else
          # COMANDO
          cd "$SELECTED_STRING" || return 1
          return 0
        fi
      else
        echo "Error: Database not initialized. Initialize it by saving your first $MANAGED_STRING"
        fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
        return 1
      fi
    fi

    return 0
}

quick-edits() {
    PROGRAM_NAME='quick-edits'
    MANAGED_STRING='file and directory path'
    UTILITY='edit the selected file or directory with $EDITOR'
    DB_NAME='quick-edits-db'
  
    ARGC=$#
    MAX_ALLOWED_ARGS=2

    if [[ $ARGC -gt $MAX_ALLOWED_ARGS ]]; then
      echo "Error: Too many arguments." >&2
      fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
    elif [[ $ARGC -gt 0 ]]; then
      case $1 in
        save)
          if [[ $ARGC -eq 2 ]]; then
            PATH_TO_ABSOLUTE=$(realpath "$2")
            if ! [[ -f "$PATH_TO_ABSOLUTE" || -d "$PATH_TO_ABSOLUTE" ]]; then
              echo "Error: The arguments for 'save' should be an existent file's or directory's path." >&2
              return 1
            fi
            # ADD TO DATABASE
            fuzzydb-engine 'save' "$DB_NAME" "$PATH_TO_ABSOLUTE"
            SAVE_RESULT=$?
            if [[ "$SAVE_RESULT" -eq 0 ]]; then
              echo "Added $PATH_TO_ABSOLUTE to the $MANAGED_STRING database."
              return 0
            elif [[ "$SAVE_RESULT" -eq 1 ]]; then
              echo "Error: $MANAGED_STRING is already in the database"
              return 1
            else
              echo "Error: Unable to save a $MANAGED_STRING to the database."
              return 1
            fi
          else
            echo "Error: Invalid number of arguments for 'save' command." >&2
            fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        delete)
          if [[ $ARGC -eq 1 ]]; then
            fuzzydb-engine 'delete' "$DB_NAME"
            if [[ $? -ne 0 ]]; then
              echo "Error: Unable to remove a $MANAGED_STRING from the database."
              return 1
            else
              echo "Removed a $MANAGED_STRING from the database."
              return 0
            fi
          else
            echo "Error: Invalid number of arguments for 'delete' command." >&2
            fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        help| --help| -h)
          # Display help message
          fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 0
          ;;
        *)
          echo "Error: Invalid command. Available commands are 'save', 'delete', and 'help'." >&2
          fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 1
          ;;
      esac
    else
      if [[ -f "$FUZZYDB_DIR"/"$DB_NAME" ]]; then
        SELECTED_STRING=$(cat "$FUZZYDB_DIR"/"$DB_NAME" | fzf) 
        if [[ $? -ne 0 ]]; then
          # When the user press escape don't do anything
          return 0
        else
          # COMANDO
          if [[ -f "$SELECTED_STRING" ]]; then
            $EDITOR "$SELECTED_STRING"
          else
            OLD_DIR=$(pwd)
            cd "$SELECTED_STRING" || return 1
            $EDITOR "$SELECTED_STRING"
            cd "$OLD_DIR" || return 1
          fi
          return 0
        fi
      else
        echo "Error: Database not initialized. Initialize it by saving your first $MANAGED_STRING"
        fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
        return 1
      fi
    fi
}

quick-bash-source() {
    PROGRAM_NAME='quick-bash-source'
    MANAGED_STRING='bash file (or directories containing only bash files)'
    UTILITY='source the selected file or directory'
    DB_NAME='quick-bash-source-db'
  
    ARGC=$#
    MAX_ALLOWED_ARGS=2

    if [[ $ARGC -gt $MAX_ALLOWED_ARGS ]]; then
      echo "Error: Too many arguments." >&2
      fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
    elif [[ $ARGC -gt 0 ]]; then
      case $1 in
        save)
          if [[ $ARGC -eq 2 ]]; then
            PATH_TO_ABSOLUTE=$(realpath "$2")
            if ! [[ -f "$PATH_TO_ABSOLUTE" || -d "$PATH_TO_ABSOLUTE" ]]; then
              echo "Error: The arguments for 'save' should be an existent file's or directory's path." >&2
              return 1
            fi
            # ADD TO DATABASE
            fuzzydb-engine 'save' "$DB_NAME" "$PATH_TO_ABSOLUTE"
            SAVE_RESULT=$?
            if [[ "$SAVE_RESULT" -eq 0 ]]; then
              echo "Added $PATH_TO_ABSOLUTE to the $MANAGED_STRING database."
              return 0
            elif [[ "$SAVE_RESULT" -eq 1 ]]; then
              echo "Error: $MANAGED_STRING is already in the database"
              return 1
            else
              echo "Error: Unable to save a $MANAGED_STRING to the database."
              return 1
            fi
          else
            echo "Error: Invalid number of arguments for 'save' command." >&2
            fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        delete)
          if [[ $ARGC -eq 1 ]]; then
            fuzzydb-engine 'delete' "$DB_NAME"
            if [[ $? -ne 0 ]]; then
              echo "Error: Unable to remove a $MANAGED_STRING from the database."
              return 1
            else
              echo "Removed a $MANAGED_STRING from the database."
              return 0
            fi
          else
            echo "Error: Invalid number of arguments for 'delete' command." >&2
            fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        help| --help| -h)
          # Display help message
          fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 0
          ;;
        *)
          echo "Error: Invalid command. Available commands are 'save', 'delete', and 'help'." >&2
          fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 1
          ;;
      esac
    else
      if [[ -f "$FUZZYDB_DIR"/"$DB_NAME" ]]; then
        SELECTED_STRING=$(cat "$FUZZYDB_DIR"/"$DB_NAME" | fzf) 
        if [[ $? -ne 0 ]]; then
          # When the user press escape don't do anything
          return 0
        else
          # COMANDO
          if [ -d "$SELECTED_STRING" ]; then
            for rc in "$SELECTED_STRING"/*; do
              if [ -f "$rc" ]; then
              . "$rc"
              fi
            done
          else
            . "$SELECTED_STRING"
          fi
          return 0
        fi
      else
        echo "Error: Database not initialized. Initialize it by saving your first $MANAGED_STRING"
        fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
        return 1
      fi
    fi
}

quick-yank() {
    PROGRAM_NAME='quick-yank'
    MANAGED_STRING='string'
    UTILITY='copy the selected string to clipboard'
    DB_NAME='quick-yank-db'
  
    ARGC=$#
    MAX_ALLOWED_ARGS=2

    if [[ $ARGC -gt $MAX_ALLOWED_ARGS ]]; then
      echo "Error: Too many arguments." >&2
      fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
    elif [[ $ARGC -gt 0 ]]; then
      case $1 in
        save)
          if [[ $ARGC -eq 2 ]]; then
            # ADD TO DATABASE
            fuzzydb-engine 'save' "$DB_NAME" "$2"
            SAVE_RESULT=$?
            if [[ "$SAVE_RESULT" -eq 0 ]]; then
              echo "Added $2 to the $MANAGED_STRING database."
              return 0
            elif [[ "$SAVE_RESULT" -eq 1 ]]; then
              echo "Error: $MANAGED_STRING is already in the database"
              return 1
            else
              echo "Error: Unable to save a $MANAGED_STRING to the database."
              return 1
            fi
          else
            echo "Error: Invalid number of arguments for 'save' command." >&2
            fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        delete)
          if [[ $ARGC -eq 1 ]]; then
            fuzzydb-engine 'delete' "$DB_NAME"
            if [[ $? -ne 0 ]]; then
              echo "Error: Unable to remove a $MANAGED_STRING from the database."
              return 1
            else
              echo "Removed a $MANAGED_STRING from the database."
              return 0
            fi
          else
            echo "Error: Invalid number of arguments for 'delete' command." >&2
            fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        help| --help| -h)
          # Display help message
          fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 0
          ;;
        *)
          echo "Error: Invalid command. Available commands are 'save', 'delete', and 'help'." >&2
          fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 1
          ;;
      esac
    else
      if [[ -f "$FUZZYDB_DIR"/"$DB_NAME" ]]; then
        SELECTED_STRING=$(cat "$FUZZYDB_DIR"/"$DB_NAME" | fzf) 
        if [[ $? -ne 0 ]]; then
          # When the user press escape don't do anything
          return 0
        else
          # COMANDO
          wl-copy "$SELECTED_STRING"
        fi
      else
        echo "Error: Database not initialized. Initialize it by saving your first $MANAGED_STRING"
        fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
        return 1
      fi
    fi
}

alias ql=quick-locations
alias qe=quick-edits
alias qs=quick-bash-source
alias qy=quick-yank
