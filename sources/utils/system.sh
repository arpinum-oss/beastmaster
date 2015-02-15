system__print_line() {
  system__print "$1"
  system__print_new_line
}

system__print() {
  printf "%s" "$1"
}

system__print_new_line() {
  printf "\n"
}

system__array_contains() {
  local value=$1
  shift 1
  local i
  for (( i=1; i <= $#; i++ )); do
    if [[ "${!i}" == "${value}" ]]; then
      return 0
    fi
  done
  return 1
}

system__print_array() {
  local element
  for element in "$@"; do
    system__print_line "${element}"
  done
}

system__dir_name() {
  system__print "${1##*\/}"
}

system__ask_for_confirmation() {
  [[ "${BST_INTERACTIVE}" == "no" ]] && return 0
  system__print "$1 (y/n) "
  local response=""
  read response < /dev/tty
  [[ "${response}" == "y" ]]
}
