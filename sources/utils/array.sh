array__contains() {
  local value="$1"
  shift 1
  local i
  for (( i=1; i <= $#; i++ )); do
    [[ "${!i}" == "${value}" ]] && return 0
  done
  return 1
}

array__print() {
  local element
  for element in "$@"; do
    system__print_line "${element}"
  done
}
