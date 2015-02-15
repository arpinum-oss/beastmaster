should_print_usage_for_help() {
  local message
  message="$(bst_tame_command__parse_args "--help")"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "Usage: bst tame"
}

should_fail_for_any_additionnal_argument() {
  local message
  message="$(bst_tame_command__parse_args "project" "bleh")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "bst tame: wrong args count -- 2 instead of 1"
}

should_add_project_to_project_list() {
  create_config_dir_for_tests
  touch "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "my_uber_project")"

  (cd "${directory}"; bst_tame_command__parse_args)

  local expected="my_uber_project:${directory}"
  assertion__equal "${expected}" "$(cat "$(bst_config__config_file)")"
}

should_add_project_with_given_name_to_project_list() {
  create_config_dir_for_tests
  touch "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "my_uber_project")"

  (cd "${directory}"; bst_tame_command__parse_args "cool_name")

  local expected="cool_name:${directory}"
  assertion__equal "${expected}" "$(cat "$(bst_config__config_file)")"
}

should_add_project_with_given_tags_to_project_list() {
  _check_taming_with_tags "--tags"
}

should_add_project_with_given_tags_to_project_list_using_short_option() {
  _check_taming_with_tags "-t"
}

_check_taming_with_tags() {
  local option="$1"
  create_config_dir_for_tests
  touch "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "my_uber_project")"

  (cd "${directory}"; bst_tame_command__parse_args "${option}=java,maven,git")

  local expected="my_uber_project:${directory}:java:maven:git"
  assertion__equal "${expected}" "$(cat "$(bst_config__config_file)")"
}

wont_add_project_if_the_name_is_already_taken() {
  create_config_dir_for_tests
  system__print_line "taken_name:directory" > "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "my_uber_project")"
  local message

  message="$(cd "${directory}"; bst_tame_command__parse_args "taken_name")"

  assertion__status_code_is_failure $?
  assertion__equal "A project named taken_name already exists." "${message}"
}

wont_add_project_if_the_directory_is_already_taken() {
  create_config_dir_for_tests
  local directory="$(create_project_dir_for_test "my_uber_project")"
  system__print_line "name:"${directory}"" > "$(bst_config__config_file)"
  local message

  message="$(cd "${directory}"; bst_tame_command__parse_args)"

  assertion__status_code_is_failure $?
  assertion__equal "A project already exists at directory "${directory}"." "${message}"
}