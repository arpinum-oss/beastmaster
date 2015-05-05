bst_config__load() {
  BST_VALUE_SEPARATOR=","
  BST_CONFIG_DIR="${HOME}/.bst"
  BST_INTERACTIVE="yes"
  BST_INSTALL_URL="https://raw.githubusercontent.com/arpinum-oss/beastmaster/master/releases/install"
  _bst_config__ensure_config_file_exists
}

_bst_config__ensure_config_file_exists() {
  if [[ ! -f "$(bst_config__config_file)" ]]; then
    mkdir -p "${BST_CONFIG_DIR}"
    system__print_line "$(_bst_config__config_file_header)" > "$(bst_config__config_file)"
  fi
}

_bst_config__config_file_header() {
  system__print "\
#
# Beastmaster config file
#
# Declare one project per line, ex:
#
# name:directory:tag1:tag2:...:tagN
#"
}

bst_config__project_lines() {
  local line
  while read line; do
    bst_config__project_line_is_commented "${line}" || system__print_line "${line}"
  done < "$(bst_config__config_file)"
}

bst_config__project_line_is_commented() {
  [[ "$1" == \#* ]]
}

bst_config__config_file() {
  system__print "${BST_CONFIG_DIR}/config"
}
