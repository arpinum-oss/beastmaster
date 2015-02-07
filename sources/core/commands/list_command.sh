function bst_list_command__run() {
  BST__CURRENT_COMMAND="list"
  command__run "$@"
}

function _bst_list_command__accepted_commands() {
  :
}

function _bst_list_command__run_default() {
  _bst_list_command__list_pets
}

function _bst_list_command__usage() {
  system__print "\
Usage: bst list

Print the project list."
}

function _bst_list_command__list_pets() {
  local line
  while read line; do
    local name="$(bst_pet__name_from_line "${line}")"
    local dir="$(bst_pet__directory_from_line "${line}")"
    local tags="$(_bst_list_comand__tags_from_line "${line}")"
    system__print_line "${name} at ${dir}${tags}"
  done < "$(bst_config__config_file)"
}

function _bst_list_comand__tags_from_line() {
  local tags="$(bst_pet__tags_from_line "$1")"
  for tag in ${tags[@]}; do
    system__print " #${tag}"
  done
}
