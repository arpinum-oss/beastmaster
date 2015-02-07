function should_create_config_file_if_it_does_not_exist() {
  BST__CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"

  bst_config__ensure_config_file_exists

  [[ -f "${BST__CONFIG_DIR}/config" ]]
  assertion__status_code_is_success $?
}

function wont_create_config_file_if_it_already_exists() {
  BST__CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"
  mkdir -p "${BST__CONFIG_DIR}"
  echo "original content" > "${BST__CONFIG_DIR}/config"

  bst_config__ensure_config_file_exists

  assertion__equal "original content" "$(cat "${BST__CONFIG_DIR}/config")"
}
