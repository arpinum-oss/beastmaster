function config_command_open_config_file_in_editor() {
  EDITOR=_mock_editor
  BST__CONFIG_DIR="${TMP_DIR}/config${RANDOM}"

  result="$(bst_config_command__run)"

  assertion__equal "editor called with: ${BST__CONFIG_DIR}/config" "${result}"
}

function _mock_editor() {
  echo "editor called with: $@"
}
