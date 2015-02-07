function when_we_ensure_config_file_exists_it_is_created_if_it_does_not_exist() {
  BST__CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"

  bst_config__ensure_config_file_exists

  [[ -f "${BST__CONFIG_DIR}/config" ]]
  assertion__status_code_is_success $?
}

function when_we_ensure_config_file_exists_it_is_not_recreated_if_it_exists() {
  BST__CONFIG_DIR="${TMP_DIR}/.bst${RANDOM}"
  mkdir -p "${BST__CONFIG_DIR}"
  echo "original content" > "${BST__CONFIG_DIR}/config"

  bst_config__ensure_config_file_exists

  assertion__equal "original content" "$(cat "${BST__CONFIG_DIR}/config")"
}
