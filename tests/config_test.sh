function should_create_config_file_if_it_does_not_exist() {
  BST__CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"

  bst_config__ensure_config_file_exists

  [[ -f "${BST__CONFIG_DIR}/config" ]]
  assertion__status_code_is_success $?
  assertion__equal "# project_name:/project/dir:tag1:tag2" "$(cat "${BST__CONFIG_DIR}/config")"
}

function wont_create_config_file_if_it_already_exists() {
  BST__CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"
  mkdir -p "${BST__CONFIG_DIR}"
  echo "original content" > "${BST__CONFIG_DIR}/config"

  bst_config__ensure_config_file_exists

  assertion__equal "original content" "$(cat "${BST__CONFIG_DIR}/config")"
}

function should_print_all_project_lines() {
   BST__CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"
  mkdir -p "${BST__CONFIG_DIR}"
  echo "first_project:first_directory" > "${BST__CONFIG_DIR}/config"
  echo "second_project:second_directory" >> "${BST__CONFIG_DIR}/config"

  local lines="$(bst_config__project_lines)"

  local expected="first_project:first_directory
second_project:second_directory"
  assertion__equal "${expected}" "${lines}"
}

function should_skip_commented_projects_when_printing_project_lines() {
   BST__CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"
  mkdir -p "${BST__CONFIG_DIR}"
  echo "# some header" > "${BST__CONFIG_DIR}/config"
  echo "first_project:first#directory" >> "${BST__CONFIG_DIR}/config"
  echo "    #commented_project:commented_directory" >> "${BST__CONFIG_DIR}/config"

  local lines="$(bst_config__project_lines)"

  assertion__equal "first_project:first#directory" "${lines}"
}
