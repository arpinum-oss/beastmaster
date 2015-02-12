function setup() {
  database__put "command_called" "false"
  database__put "command_arg" ""
}

function should_print_usage_for_help() {
  local message
  message="$(bst_program__run "--help")"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "Usage: bst <command>"
}

function should_fail_if_option_is_illegal() {
  local message
  message="$(bst_program__run "--bleh")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "bst: illegal option -- bleh"
}

function should_fail_if_command_is_illegal() {
  local message
  message="$(bst_program__run "bleh")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "bst: illegal command -- bleh"
}

function should_call_config_command() {
  mock__make_function_call "bst_config_command__parse_args" "_capture_call"

  ( bst_program__run "config" "--with-arg" )

  assertion__status_code_is_success $?
  assertion__equal "true" "$(database__get "command_called")"
  assertion__equal "--with-arg" "$(database__get "command_arg")"
}

function should_call_free_command() {
  mock__make_function_call "bst_free_command__parse_args" "_capture_call"

  ( bst_program__run "free" "--with-arg" )

  assertion__status_code_is_success $?
  assertion__equal "true" "$(database__get "command_called")"
  assertion__equal "--with-arg" "$(database__get "command_arg")"
}

function should_call_list_command() {
  mock__make_function_call "bst_list_command__parse_args" "_capture_call"

  ( bst_program__run "list" "--with-arg" )

  assertion__status_code_is_success $?
  assertion__equal "true" "$(database__get "command_called")"
  assertion__equal "--with-arg" "$(database__get "command_arg")"
}

function should_call_order_command() {
  mock__make_function_call "bst_order_command__parse_args" "_capture_call"

  ( bst_program__run "order" "--with-arg" )

  assertion__status_code_is_success $?
  assertion__equal "true" "$(database__get "command_called")"
  assertion__equal "--with-arg" "$(database__get "command_arg")"
}

function should_call_tame_command() {
  mock__make_function_call "bst_tame_command__parse_args" "_capture_call"

  ( bst_program__run "tame" "--with-arg" )

  assertion__status_code_is_success $?
  assertion__equal "true" "$(database__get "command_called")"
  assertion__equal "--with-arg" "$(database__get "command_arg")"
}

function _capture_call() {
  database__put "command_called" "true"
  database__put "command_arg" "$1"
}
