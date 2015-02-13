bst_project__name_from_line() {
  _bst_project__first_token "$1"
}

bst_project__directory_from_line() {
  local without_name="$(_bst_project__without_first_token "$1")"
  _bst_project__first_token "${without_name}"
}

bst_project__tags_from_line() {
  local without_name="$(_bst_project__without_first_token "$1")"
  local only_tags="$(_bst_project__without_first_token "${without_name}")"
  while [[ -n "${only_tags}" ]]; do
    _bst_project__first_token "${only_tags}"
    system__print_new_line
    only_tags="$(_bst_project__without_first_token "${only_tags}")"
  done
}

_bst_project__first_token() {
  system__print "${1%%:*}"
}

_bst_project__without_first_token() {
  [[ "$1" == *:* ]] && system__print "${1#*:}"
}
