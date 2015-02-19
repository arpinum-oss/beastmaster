option__name() {
  local option="${1%=*}"
  option="${option#-}"
  system__print "${option#-}"
}

option__value() {
  if [[ "$1" == *=* ]]; then
    system__print "${1#*=}"
  else
    system__print "yes"
  fi
}

option__short_option_from_string() {
  string__token_at 1 "$1"
}

option__long_option_from_string() {
  string__token_at 2 "$1"
}

option__variable_from_string() {
  string__token_at 3 "$1"
}
