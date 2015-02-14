option__name() {
  local option="${1%=*}"
  option="${option#-}"
  system__print "${option#-}"
}

option__value() {
  system__print "${1#*=}"
}

option__short_option_from_string() {
  token__at 1 "$1"
}

option__long_option_from_string() {
  token__at 2 "$1"
}

option__variable_from_string() {
  token__at 3 "$1"
}
