function bst_config_command__run() {
  BST__CURRENT_COMMAND="config"
  command__run "$@"
}

function _bst_config_command__accepted_commands() {
  :
}

function _bst_config_command__run_default() {
  "${EDITOR}" "$(bst_config__config_file)"
}

function _bst_config_command__usage() {
  system__print "\
Usage: bst config

Edit the configuration."
}
