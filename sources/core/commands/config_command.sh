function bst_config_command__run() {
  BST__CURRENT_COMMAND="config"
  "${EDITOR}" "$(bst_config__config_file)"
}
