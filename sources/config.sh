function bst_config__load() {
  BST__CONFIG_DIR="${HOME}/.bst"
  bst_config__ensure_config_file_exists
}

function bst_config__ensure_config_file_exists() {
  if [[ ! -f "$(bst_config__config_file)" ]]; then
    mkdir -p "${BST__CONFIG_DIR}"
    system__print_line "# project_name:/project/dir:tag1:tag2" > "$(bst_config__config_file)"
  fi
}

function bst_config__project_lines() {
  local line
  while read line; do
    [[ "${line}" != \#* ]] && system__print_line "${line}"
  done < "$(bst_config__config_file)"
}

function bst_config__config_file() {
  system__print "${BST__CONFIG_DIR}/config"
}
