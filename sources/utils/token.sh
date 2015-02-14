token__at() {
  local position="$1"
  local string="$2"
  local i
  for (( i=1; i < ${position}; i++ )); do
    string="$(token__without_first "${string}")"
  done
  system__print "${string%%:*}"
}

token__without_first() {
  [[ "$1" == *:* ]] && system__print "${1#*:}"
}
