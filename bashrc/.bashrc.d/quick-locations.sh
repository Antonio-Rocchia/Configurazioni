#!/bin/bash
FUZZYDB_DIR="$HOME/.config/fuzzydb"

_fuzzydb-engine () {
    ARGC=$#
    ALLOWED_ARGS=3
    
    if [[ $ARGC -ne $ALLOWED_ARGS ]]; then
      return 1
    fi
    
    OP=$1
    DB_NAME=$2
    STRING=$3

    OLD_DIR=$(pwd)
    mkdir -p "$FUZZYDB_DIR"
    cd "$FUZZYDB_DIR"
    touch "$DB_NAME"

    case "$OP" in
      save)
          echo "$STRING" >> "$DB_NAME"
          cd "$OLD_DIR"
          return 0
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

        cd "$OLD_DIR"
        return 0
        ;;
      *)
        cd "$OLD_DIR"
        return 1
        ;;
    esac
}

_fuzzydb-usage() {
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
      _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
    elif [[ $ARGC -gt 0 ]]; then
      case $1 in
        save)
          if [[ $ARGC -eq 2 ]]; then
            PATH_TO_ABSOLUTE=$(realpath $2)
            if ! [[ -d "$PATH_TO_ABSOLUTE" ]]; then
              echo "Error: The arguments for 'save' should be an existent directory's path." >&2
              return 1
            fi
            # ADD TO DATABASE
            _fuzzydb-engine 'save' "$DB_NAME" "$PATH_TO_ABSOLUTE"
            if [[ $? -ne 0 ]]; then
              echo "Error: Unable to save a $MANAGED_STRING to the database."
              return 1
            else
              echo "Added $PATH_TO_ABSOLUTE to the $MANAGED_STRING database."
              return 0
            fi
          else
            echo "Error: Invalid number of arguments for 'save' command." >&2
            _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        delete)
          if [[ $ARGC -eq 1 ]]; then
            _fuzzydb-engine 'delete' "$DB_NAME" "$PATH_TO_ABSOLUTE"
            if [[ $? -ne 0 ]]; then
              echo "Error: Unable to remove a $MANAGED_STRING from the database."
              return 1
            else
              echo "Removed a $MANAGED_STRING from the database."
              return 0
            fi
          else
            echo "Error: Invalid number of arguments for 'delete' command." >&2
            _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        help| --help| -h)
          # Display help message
          _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 0
          ;;
        *)
          echo "Error: Invalid command. Available commands are 'save', 'delete', and 'help'." >&2
          _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 1
          ;;
      esac
    else
      if [[ -f "$FUZZYDB_DIR"/"$DB_NAME" ]]; then
        SELECTED_STRING=$(cat "$FUZZYDB_DIR"/"$DB_NAME" | fzf) 
        if [[ SELECTED_STRING = "" ]]; then
          # When the user press escape don't do anything
          return 0
        else
          # COMANDO
          cd "$SELECTED_STRING"
          return 0
        fi
      else
        echo "Error: Database not initialized. Initialize it by saving your first $MANAGED_STRING"
        _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
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
      _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
    elif [[ $ARGC -gt 0 ]]; then
      case $1 in
        save)
          if [[ $ARGC -eq 2 ]]; then
            PATH_TO_ABSOLUTE=$(realpath $2)
            if ! [[ -f "$PATH_TO_ABSOLUTE" || -d "$PATH_TO_ABSOLUTE" ]]; then
              echo "Error: The arguments for 'save' should be an existent file's or directory's path." >&2
              return 1
            fi
            # ADD TO DATABASE
            _fuzzydb-engine 'save' "$DB_NAME" "$PATH_TO_ABSOLUTE"
            if [[ $? -ne 0 ]]; then
              echo "Error: Unable to save a $MANAGED_STRING to the database."
              return 1
            else
              echo "Added $PATH_TO_ABSOLUTE to the $MANAGED_STRING database."
              return 0
            fi
          else
            echo "Error: Invalid number of arguments for 'save' command." >&2
            _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        delete)
          if [[ $ARGC -eq 1 ]]; then
            _fuzzydb-engine 'delete' "$DB_NAME" "$PATH_TO_ABSOLUTE"
            if [[ $? -ne 0 ]]; then
              echo "Error: Unable to remove a $MANAGED_STRING from the database."
              return 1
            else
              echo "Removed a $MANAGED_STRING from the database."
              return 0
            fi
          else
            echo "Error: Invalid number of arguments for 'delete' command." >&2
            _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
            return 1
          fi
          ;;
        help| --help| -h)
          # Display help message
          _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 0
          ;;
        *)
          echo "Error: Invalid command. Available commands are 'save', 'delete', and 'help'." >&2
          _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
          return 1
          ;;
      esac
    else
      if [[ -f "$FUZZYDB_DIR"/"$DB_NAME" ]]; then
        SELECTED_STRING=$(cat "$FUZZYDB_DIR"/"$DB_NAME" | fzf) 
        if [[ SELECTED_STRING = "" ]]; then
          # When the user press escape don't do anything
          return 0
        else
          # COMANDO
          $EDITOR "$SELECTED_STRING"
          return 0
        fi
      else
        echo "Error: Database not initialized. Initialize it by saving your first $MANAGED_STRING"
        _fuzzydb-usage "$PROGRAM_NAME" "$MANAGED_STRING" "$UTILITY"
        return 1
      fi
    fi
}

# quick-yank()

alias ql=quick-locations
alias qe=quick-edits
