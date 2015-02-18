before() {
  bst_projects__reset_filters
}

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

should_print_project_lines_filtered_by_name() {
  create_config_dir_for_tests
  echo "first_project:first_directory" > "${BST_CONFIG_DIR}/config"
  echo "second_project:second_directory" >> "${BST_CONFIG_DIR}/config"
  bst_project_filter_name="second_project"

  local lines="$(bst_projects__filtered_lines)"

  assertion__equal "second_project:second_directory" "${lines}"
}

should_print_project_lines_filtered_by_name_alike() {
  create_config_dir_for_tests
  echo "first_project:first_directory" > "${BST_CONFIG_DIR}/config"
  echo "second_project:second_directory" >> "${BST_CONFIG_DIR}/config"
  bst_project_filter_name="*proj*"

  local lines="$(bst_projects__filtered_lines)"

  local expected="first_project:first_directory
second_project:second_directory"
  assertion__equal "${expected}" "${lines}"
}

should_print_project_lines_filtered_by_tags() {
  create_config_dir_for_tests
  echo "first_project:first_directory:git:bash" > "${BST_CONFIG_DIR}/config"
  echo "second_project:second_directory:svn" >> "${BST_CONFIG_DIR}/config"
  echo "third_project:third_directory:bash" >> "${BST_CONFIG_DIR}/config"
  echo "forth_project:forth_directory:cpp:git" >> "${BST_CONFIG_DIR}/config"
  bst_project_filter_tags=("git" "bash")

  local lines="$(bst_projects__filtered_lines)"

  local expected="first_project:first_directory:git:bash
third_project:third_directory:bash
forth_project:forth_directory:cpp:git"
  assertion__equal "${expected}" "${lines}"
}
