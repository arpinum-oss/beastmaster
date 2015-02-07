function system__print_line() {
  system__print "$1"
  system__print_new_line
}

function system__print() {
  printf "%s" "$1"
}

function system__print_new_line() {
  printf "\n"
}
