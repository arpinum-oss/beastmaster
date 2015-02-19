bst_project__name_from_line() {
  string__token_at 1 "$1"
}

bst_project__directory_from_line() {
  string__token_at 2 "$1"
}

bst_project__tags_from_line() {
  local without_name="$(string__without_first_token "$1")"
  local only_tags="$(string__without_first_token "${without_name}")"
  while [[ -n "${only_tags}" ]]; do
    string__token_at 1 "${only_tags}"
    system__print_new_line
    only_tags="$(string__without_first_token "${only_tags}")"
  done
}
