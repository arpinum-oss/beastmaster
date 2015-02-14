option__name() {
  local option="${1%=*}"
  option="${option#-}"
  system__print "${option#-}"
}

option__value() {
  system__print "${1#*=}"
}
