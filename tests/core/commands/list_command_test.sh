should_print_usage_for_help() {
  local message
  message="$(bst_list_command__parse_args --help)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "Usage: bst list"
}

should_fail_for_any_additionnal_argument() {
  local message
  message="$(bst_list_command__parse_args "bleh")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "Wrong args count: 1 instead of 0"
}

should_print_simple_projects() {
  create_config_dir_for_tests
  echo "cool-project:/home/alone/dev/cool-project" > "$(bst_config__config_file)"
  echo "bowling-kata:/home/alone/dev/kata/bowling-kata" >> "$(bst_config__config_file)"

  result="$(bst_list_command__parse_args)"

  assertion__equal "$(_expected_simple_output)" "${result}"
}

_expected_simple_output() {
  echo "cool-project at /home/alone/dev/cool-project"
  echo "bowling-kata at /home/alone/dev/kata/bowling-kata"
}

should_print_projects_with_tags() {
  create_config_dir_for_tests
  echo "cool-project:/home/alone/dev/cool-project:java:git:hobby" > "$(bst_config__config_file)"
  echo "bowling-kata:/home/alone/dev/kata/bowling-kata:python:training" >> "$(bst_config__config_file)"

  result="$(bst_list_command__parse_args)"

  assertion__equal "$(_expected_output_with_tags)" "${result}"
}

_expected_output_with_tags() {
  echo "cool-project at /home/alone/dev/cool-project #java #git #hobby"
  echo "bowling-kata at /home/alone/dev/kata/bowling-kata #python #training"
}
