should_print_usage_for_help() {
  local message

  message="$(bst_order_command__parse_args --help)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "Usages: bst order"
}

should_print_usage_with_no_argument() {
  local message

  message="$(bst_order_command__parse_args)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "Usages: bst order"
}

should_order_command_for_all_projects() {
  create_config_dir_for_tests
  local bowling_kata_dir="$(create_project_dir_for_test "bowling-kata")"
  echo "bowling-kata:${bowling_kata_dir}" > "$(bst_config__config_file)"
  local tennis_kata_dir="$(create_project_dir_for_test "tennis-kata")"
  echo "tennis-kata:${tennis_kata_dir}" >> "$(bst_config__config_file)"
  local result

  result="$(bst_order_command__parse_args --all pwd)"

  assertion__status_code_is_success $?
  assertion__equal "${bowling_kata_dir}"$'\n'"${tennis_kata_dir}" "${result}"
}

should_order_command_for_project_with_name() {
  create_config_dir_for_tests
  local bowling_kata_dir="$(create_project_dir_for_test "bowling-kata")"
  echo "cool-project:/home/alone/dev/cool-project" > "$(bst_config__config_file)"
  echo "bowling-kata:${bowling_kata_dir}" >> "$(bst_config__config_file)"
  local result

  result="$(bst_order_command__parse_args "bowling-kata" pwd)"

  assertion__status_code_is_success $?
  assertion__equal "${bowling_kata_dir}" "${result}"
}

should_order_command_for_project_with_name_as_option() {
  create_config_dir_for_tests
  local bowling_kata_dir="$(create_project_dir_for_test "bowling-kata")"
  echo "cool-project:/home/alone/dev/cool-project" > "$(bst_config__config_file)"
  echo "bowling-kata:${bowling_kata_dir}" >> "$(bst_config__config_file)"
  local result

  result="$(bst_order_command__parse_args --name=bowling-kata pwd)"

  assertion__status_code_is_success $?
  assertion__equal "${bowling_kata_dir}" "${result}"
}

should_order_command_for_project_with_tag() {
  create_config_dir_for_tests
  echo "cool-project:/home/alone/dev/cool-project" > "$(bst_config__config_file)"
  local bowling_kata_dir="$(create_project_dir_for_test "bowling-kata")"
  echo "bowling-kata:${bowling_kata_dir}:kata" >> "$(bst_config__config_file)"
  local tennis_kata_dir="$(create_project_dir_for_test "tennis-kata")"
  echo "tennis-kata:${tennis_kata_dir}:git" >> "$(bst_config__config_file)"
  local result

  result="$(bst_order_command__parse_args --tags=kata,git pwd)"

  assertion__status_code_is_success $?
  assertion__equal "${bowling_kata_dir}"$'\n'"${tennis_kata_dir}" "${result}"
}

should_order_command_for_project_with_tag_and_name() {
  create_config_dir_for_tests
  local bowling_kata_dir="$(create_project_dir_for_test "bowling-kata")"
  echo "bowling-kata:${bowling_kata_dir}:kata" > "$(bst_config__config_file)"
  local tennis_kata_dir="$(create_project_dir_for_test "tennis-kata")"
  echo "tennis-kata:${tennis_kata_dir}:git" >> "$(bst_config__config_file)"
  local result

  result="$(bst_order_command__parse_args --name=bowling-kata --tags=kata,git pwd)"

  assertion__status_code_is_success $?
  assertion__equal "${bowling_kata_dir}" "${result}"
}

should_order_multi_word_command() {
  create_config_dir_for_tests
  local bowling_kata_dir="$(create_project_dir_for_test "bowling-kata")"
  echo "bowling-kata:${bowling_kata_dir}" > "$(bst_config__config_file)"
  local result

  result="$(bst_order_command__parse_args "bowling-kata" echo a b c)"

  assertion__equal "a b c" "${result}"
}

should_preserve_command_args() {
  create_config_dir_for_tests
  local bowling_kata_dir="$(create_project_dir_for_test "bowling-kata")"
  echo "bowling-kata:${bowling_kata_dir}" > "$(bst_config__config_file)"
  local result

  result="$(bst_order_command__parse_args "bowling-kata" _count_args "a b" c)"

  assertion__equal 2 "${result}"
}

_count_args() {
  system__print $#
}

should_order_command_with_options() {
  create_config_dir_for_tests
  local bowling_kata_dir="$(create_project_dir_for_test "bowling-kata")"
  echo "bowling-kata:${bowling_kata_dir}" > "$(bst_config__config_file)"
  local result

  result="$(bst_order_command__parse_args "bowling-kata" _print_option --option)"

  assertion__equal "--option" "${result}"
}

_print_option() {
  system__print "$1"
}

should_print_project_information_with_verbose_option() {
  create_config_dir_for_tests
  local bowling_kata_dir="$(create_project_dir_for_test "bowling-kata")"
  echo "bowling-kata:${bowling_kata_dir}" > "$(bst_config__config_file)"
  local messages

  messages="$(bst_order_command__parse_args -v "bowling-kata" pwd)"

  local expected="Ordering command in ${bowling_kata_dir} for bowling-kata.
${bowling_kata_dir}"
  assertion__equal "${expected}" "${messages}"
}

should_fail_if_directory_does_not_exist() {
  create_config_dir_for_tests
  echo "cool-project:/home/alone/dev/cool-project" > "$(bst_config__config_file)"
  echo "other-project:/home/alone/dev/other-project" >> "$(bst_config__config_file)"
  local message

  message="$(bst_order_command__parse_args "cool-project" pwd)"

  assertion__status_code_is_failure $?
  assertion__equal "/home/alone/dev/cool-project does not exist for cool-project." "${message}"
}
