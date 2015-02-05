function bst_config_command__run() {
  bst_config__ensure_config_file_exists
  "${EDITOR}" "$(bst_config__config_file)"
}
