should_print_usage_for_help() {
  local message
  message="$(bst_free_command__parse_args "--help")"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "Usage: bst free"
}

should_fail_for_any_additionnal_argument() {
  local message
  message="$(bst_free_command__parse_args "project" "bleh")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "bst free: wrong args count -- 2 instead of 1"
}

should_remove_project_from_config() {
  create_config_dir_for_tests
  echo "cool-project:/home/alone/dev/cool-project" > "$(bst_config__config_file)"

  bst_free_command__parse_args "cool-project"

  assertion__status_code_is_success $?
  assertion__equal "" "$(cat "$(bst_config__config_file)")"
}

should_remove_current_project_from_config_if_no_name_is_given() {
  create_config_dir_for_tests
  echo "cool-project:/home/alone/dev/cool-project" > "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "cool-project")"

  (cd "${directory}"; bst_free_command__parse_args)

  assertion__status_code_is_success $?
  assertion__equal "" "$(cat "$(bst_config__config_file)")"
}

should_fail_if_project_does_not_exists() {
  create_config_dir_for_tests
  local message

  message="$(bst_free_command__parse_args "cool-project")"

  assertion__status_code_is_failure $?
  assertion__equal "${message}" "No project with name cool-project."
}

should_ignore_comments_when_removing_project() {
  create_config_dir_for_tests
  local line="# cool-project:/home/alone/dev/cool-project"
  echo "${line}" > "$(bst_config__config_file)"
  local message

  message="$(bst_free_command__parse_args "cool-project")"

  assertion__status_code_is_failure $?
  assertion__equal "${message}" "No project with name cool-project."
}

