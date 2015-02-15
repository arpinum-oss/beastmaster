bst_list_command__parse_args() {
  command__define_current_command "list"
  command__parse_args "$@"
}

_bst_list_command__run() {
  command__check_args_count 0 $#
  bst_projects__for_each_line _bst_list_command__print_line
}

_bst_list_command__print_line() {
  local line="$1"
  local name="$(bst_project__name_from_line "${line}")"
  local dir="$(bst_project__directory_from_line "${line}")"
  local tags="$(_bst_list_command__tags_from_line "${line}")"
  system__print_line "${name} at ${dir}${tags}"
}

_bst_list_command__tags_from_line() {
  local tag
  while read tag; do
    system__print " #${tag}"
  done < <(bst_project__tags_from_line "$1")
}

_bst_list_command__usage() {
  system__print "\
Usage: bst list

Print your project list."
}
