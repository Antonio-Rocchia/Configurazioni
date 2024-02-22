export TODOTXT_DEFAULT_ACTION=ls
export TODOTXT_SORT_COMMAND='env LC_COLLATE=C sort -k 2,2 -k 1,1n'
complete -F _todo t
alias t='/home/tonino/Eseguibili/todo.txt_cli-2.12.0/todo.sh'

