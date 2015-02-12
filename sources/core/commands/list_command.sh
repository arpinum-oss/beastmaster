function bst_list_command__parse_args() {
  command__define_current_command "list"
  command__parse_args "$@"
}

function _bst_list_command__run() {
  command__check_args_count 0 $#
  local line
  for line in $(bst_config__project_lines); do
    local name="$(bst_project__name_from_line "${line}")"
    local dir="$(bst_project__directory_from_line "${line}")"
    local tags="$(_bst_list_command__tags_from_line "${line}")"
    system__print_line "${name} at ${dir}${tags}"
  done
}

function _bst_list_command__tags_from_line() {
  local tags="$(bst_project__tags_from_line "$1")"
  for tag in ${tags[@]}; do
    system__print " #${tag}"
  done
}

function _bst_list_command__usage() {
  system__print "\
Usage: bst list

Print your project list."
}
