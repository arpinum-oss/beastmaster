should_print_usage_for_help() {
  local message
  message="$(bst_config_command__parse_args "--help")"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "Usage: bst config"
}

should_fail_for_any_additionnal_argument() {
  local message
  message="$(bst_config_command__parse_args "bleh")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "bst config: wrong args count -- 1 instead of 0"
}

should_open_config_file_in_editor() {
  EDITOR=_mock_editor
  create_config_dir_for_tests

  local result="$(bst_config_command__parse_args)"

  assertion__equal "editor called with: ${BST__CONFIG_DIR}/config" "${result}"
}

_mock_editor() {
  echo "editor called with: $@"
}

should_fail_if_editor_is_not_set() {
  EDITOR=""
  create_config_dir_for_tests
  local message

  message="$(bst_config_command__parse_args)"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "EDITOR environment variable must be set"
}
