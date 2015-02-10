function create_config_dir_for_tests() {
  BST__CONFIG_DIR="${TMP_DIR}/config${RANDOM}"
  mkdir -p "${BST__CONFIG_DIR}"
}
