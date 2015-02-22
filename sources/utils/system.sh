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

system__dir_name() {
  system__print "${1##*\/}"
}

system__dir_path() {
  (cd "$1"; pwd)
}

system__ask_for_confirmation() {
  [[ "${BST_INTERACTIVE}" == "no" ]] && return 0
  system__print "$1 (y/n) "
  local response=""
  read response < /dev/tty
  [[ "${response}" == "y" || -z "${response}" ]]
}
