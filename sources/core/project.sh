bst_project__name_from_line() {
  token__at 1 "$1"
}

bst_project__directory_from_line() {
  token__at 2 "$1"
}

bst_project__tags_from_line() {
  local without_name="$(token__without_first "$1")"
  local only_tags="$(token__without_first "${without_name}")"
  while [[ -n "${only_tags}" ]]; do
    token__at 1 "${only_tags}"
    system__print_new_line
    only_tags="$(token__without_first "${only_tags}")"
  done
}
