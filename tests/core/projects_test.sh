should_tell_if_project_exists_for_name() {
  create_config_dir_for_tests
  echo "first_project:first_directory" > "${BST_CONFIG_DIR}/config"
  echo "second_project:second_directory" >> "${BST_CONFIG_DIR}/config"

  assertion__successful bst_projects__exists_with_name "second_project"
  assertion__failing bst_projects__exists_with_name "plop"
}

should_tell_if_project_exists_for_directory() {
  create_config_dir_for_tests
  echo "first_project:first_directory" > "${BST_CONFIG_DIR}/config"
  echo "second_project:second_directory" >> "${BST_CONFIG_DIR}/config"

  assertion__successful bst_projects__exists_with_directory "second_directory"
  assertion__failing bst_projects__exists_with_directory "plop"
}

should_execute_something_for_each_line() {
  create_config_dir_for_tests
  echo "first_project:first_directory" > "${BST_CONFIG_DIR}/config"
  echo "second_project:second_directory" >> "${BST_CONFIG_DIR}/config"

  local lines="$(bst_projects__for_each_line echo)"

  local expected="first_project:first_directory
second_project:second_directory"
  assertion__equal "${expected}" "${lines}"
}

should_print_project_line_with_corresponding_name() {
  create_config_dir_for_tests
  echo "first_project:first_directory" > "${BST_CONFIG_DIR}/config"
  echo "second_project:second_directory" >> "${BST_CONFIG_DIR}/config"

  local lines="$(bst_projects__lines_with_name "second_project")"

  assertion__equal "second_project:second_directory" "${lines}"
}
