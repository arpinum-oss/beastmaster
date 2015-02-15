should_create_config_file_if_it_does_not_exist() {
  BST_CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"

  _bst_config__ensure_config_file_exists

  [[ -f "${BST_CONFIG_DIR}/config" ]]
  assertion__status_code_is_success $?
  assertion__string_contains "$(cat "${BST_CONFIG_DIR}/config")" "Beastmaster config file"
}

wont_create_config_file_if_it_already_exists() {
  BST_CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"
  mkdir -p "${BST_CONFIG_DIR}"
  echo "original content" > "${BST_CONFIG_DIR}/config"

  _bst_config__ensure_config_file_exists

  assertion__equal "original content" "$(cat "${BST_CONFIG_DIR}/config")"
}

should_print_all_project_lines() {
  BST_CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"
  mkdir -p "${BST_CONFIG_DIR}"
  echo "first_project:first_directory" > "${BST_CONFIG_DIR}/config"
  echo "second_project:second_directory" >> "${BST_CONFIG_DIR}/config"

  local lines="$(bst_config__project_lines)"

  local expected="first_project:first_directory
second_project:second_directory"
  assertion__equal "${expected}" "${lines}"
}

should_skip_commented_projects_when_printing_project_lines() {
  BST_CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"
  mkdir -p "${BST_CONFIG_DIR}"
  echo "# some header" > "${BST_CONFIG_DIR}/config"
  echo "first_project:first#directory" >> "${BST_CONFIG_DIR}/config"
  echo "    #commented_project:commented_directory" >> "${BST_CONFIG_DIR}/config"

  local lines="$(bst_config__project_lines)"

  assertion__equal "first_project:first#directory" "${lines}"
}
