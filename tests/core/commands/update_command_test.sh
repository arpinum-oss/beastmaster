should_print_usage_for_help() {
  local message
  message="$(bst_update_command__parse_args --help)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "Usage: bst update"
}

should_fail_for_any_additionnal_argument() {
  local message
  message="$(bst_update_command__parse_args "bleh")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "Wrong args count: 1 instead of 0"
}
