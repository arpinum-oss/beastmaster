function bst_config__load() {
  BST__CONFIG_DIR="${HOME}/.bst"
  bst_config__ensure_config_file_exists
}

function bst_config__config_file() {
  system__print "${BST__CONFIG_DIR}/config"
}

function bst_config__ensure_config_file_exists() {
  mkdir -p "${BST__CONFIG_DIR}"
  touch "$(bst_config__config_file)"
}
