function bst_pet__name_from_line() {
  _bst_pet__first_token "$1"
}

function bst_pet__directory_from_line() {
  local without_name="$(_bst_pet__without_first_token "$1")"
  _bst_pet__first_token "${without_name}"
}

function bst_pet__tags_from_line() {
  local without_name="$(_bst_pet__without_first_token "$1")"
  local only_tags="$(_bst_pet__without_first_token "${without_name}")"
  while [[ -n "${only_tags}" ]]; do
    _bst_pet__first_token "${only_tags}"
    system__print_new_line
    only_tags="$(_bst_pet__without_first_token "${only_tags}")"
  done
}

function _bst_pet__first_token() {
  system__print "${1%%:*}"
}

function _bst_pet__without_first_token() {
  [[ "$1" == *:* ]] && system__print "${1#*:}"
}
