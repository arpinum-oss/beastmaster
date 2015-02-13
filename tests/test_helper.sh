create_config_dir_for_tests() {
  BST__CONFIG_DIR="${TMP_DIR}/config${RANDOM}"
  mkdir -p "${BST__CONFIG_DIR}"
}

create_project_dir_for_test() {
  local directory="${TMP_DIR}/$1"
  mkdir -p "${directory}"
  system__print "${directory}"
}
