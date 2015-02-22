should_print_usage_for_help() {
  local message

  message="$(bst_tame_command__parse_args --help)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "Usage: bst tame"
}

should_fail_for_any_additionnal_argument() {
  local message

  message="$(bst_tame_command__parse_args "project" "bleh")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "Wrong args count: 2 instead of 1"
}

should_add_current_project_to_project_list() {
  create_config_dir_for_tests
  touch "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "my_uber_project")"

  (cd "${directory}"; bst_tame_command__parse_args)

  local expected="my_uber_project:${directory}"
  assertion__equal "${expected}" "$(cat "$(bst_config__config_file)")"
}

should_add_distant_project_to_project_list() {
  create_config_dir_for_tests
  touch "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "my_uber_project")"

  bst_tame_command__parse_args --directory "${directory}"

  local expected="my_uber_project:${directory}"
  assertion__equal "${expected}" "$(cat "$(bst_config__config_file)")"
}

should_add_relative_project_to_project_list() {
  create_config_dir_for_tests
  touch "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "my_uber_project")"

  (cd "${directory}"; bst_tame_command__parse_args --directory "../my_uber_project")

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
  _check_taming_with_tags --tags
}

should_add_project_with_given_tags_to_project_list_using_short_option() {
  _check_taming_with_tags -t
}

_check_taming_with_tags() {
  local option="$1"
  create_config_dir_for_tests
  touch "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "my_uber_project")"

  (cd "${directory}"; bst_tame_command__parse_args "${option}" "java,maven,git")

  local expected="my_uber_project:${directory}:java:maven:git"
  assertion__equal "${expected}" "$(cat "$(bst_config__config_file)")"
}

should_add_all_child_projects_in_the_current_directory_to_project_list() {
  create_config_dir_for_tests
  touch "$(bst_config__config_file)"
  local root="$(create_project_dir_for_test "root")"
  mkdir -p "${root}/first_project"
  mkdir -p "${root}/second_project"

  (cd "${root}"; bst_tame_command__parse_args --root)

  local expected="first_project:${root}/first_project
second_project:${root}/second_project"
  assertion__equal "${expected}" "$(cat "$(bst_config__config_file)")"
}

should_add_all_child_projects_in_the_distant_directory_to_project_list() {
  create_config_dir_for_tests
  touch "$(bst_config__config_file)"
  local root="$(create_project_dir_for_test "root")"
  mkdir -p "${root}/first_project"
  mkdir -p "${root}/second_project"

  bst_tame_command__parse_args --root --directory "${root}"

  local expected="first_project:${root}/first_project
second_project:${root}/second_project"
  assertion__equal "${expected}" "$(cat "$(bst_config__config_file)")"
}

wont_add_file_in_the_root_directory() {
  create_config_dir_for_tests
  touch "$(bst_config__config_file)"
  local root="$(create_project_dir_for_test "root")"
  touch "${root}/some_file"

  (cd "${root}"; bst_tame_command__parse_args --root)

  assertion__equal "" "$(cat "$(bst_config__config_file)")"
}

should_fail_if_both_root_and_name_are_wanted_at_the_same_time() {
  local message

  message="$(cd "${TMP_DIR}"; bst_tame_command__parse_args --root "project_name")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "bst tame: you should not tame root directory and provide a name."
}

wont_add_project_if_the_name_is_already_taken() {
  create_config_dir_for_tests
  system__print_line "taken_name:directory" > "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "my_uber_project")"
  local message

  message="$(cd "${directory}"; bst_tame_command__parse_args "taken_name")"

  assertion__status_code_is_success $?
  assertion__equal "A project named taken_name already exists so project won't be tamed." "${message}"
}

wont_add_project_if_the_directory_is_already_taken() {
  create_config_dir_for_tests
  local directory="$(create_project_dir_for_test "my_uber_project")"
  system__print_line "name:${directory}" > "$(bst_config__config_file)"
  local message

  message="$(cd "${directory}"; bst_tame_command__parse_args)"

  assertion__status_code_is_success $?
  assertion__equal "A project already exists at directory ${directory} so project won't be tamed." "${message}"
}

wont_add_project_if_the_name_contains_a_colon() {
  create_config_dir_for_tests
  system__print_line "taken_name:directory" > "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "my_uber_project")"
  local message

  message="$(cd "${directory}"; bst_tame_command__parse_args "with:colon")"

  assertion__status_code_is_success $?
  assertion__equal "The project name contains a colon which is forbidden so project won't be tamed." "${message}"
}

wont_add_project_if_a_tag_contains_a_colon() {
  create_config_dir_for_tests
  touch "$(bst_config__config_file)"
  local directory="$(create_project_dir_for_test "my_uber_project")"
  local message

  message="$(cd "${directory}"; bst_tame_command__parse_args -t "java,mav:en")"

  assertion__status_code_is_success $?
  assertion__equal "A tag contains a colon which is forbidden so project won't be tamed." "${message}"
}
