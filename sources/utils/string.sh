string__token_at() {
  local position="$1"
  local string="$2"
  local i
  for (( i=1; i < ${position}; i++ )); do
    string="$(string__without_first_token "${string}")"
  done
  system__print "${string%%:*}"
}

string__without_first_token() {
  [[ "$1" == *:* ]] && system__print "${1#*:}"
}

string__split() {
  local old_ifs="${IFS}"
  IFS="${BST_VALUE_SEPARATOR}"
  for value in $1; do
    system__print_line "${value}"
  done
  IFS="${old_ifs}"
}
