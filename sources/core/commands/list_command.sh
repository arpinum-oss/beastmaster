function bst_list_command__run() {
  BST__CURRENT_COMMAND="list"
  command__run "$@"
}

function _bst_list_command__with_sub_commands() {
  return 1
}

function _bst_list_command__arguments_count() {
  system__print "0"
}

function _bst_list_command__run_default() {
  local line
  for line in $(bst_config__project_lines); do
    local name="$(bst_project__name_from_line "${line}")"
    local dir="$(bst_project__directory_from_line "${line}")"
    local tags="$(_bst_list_comand__tags_from_line "${line}")"
    system__print_line "${name} at ${dir}${tags}"
  done
}

function _bst_list_comand__tags_from_line() {
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
