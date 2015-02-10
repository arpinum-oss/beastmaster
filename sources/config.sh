function bst_config__load() {
  BST__CONFIG_DIR="${HOME}/.bst"
  bst_config__ensure_config_file_exists
}

function bst_config__ensure_config_file_exists() {
  if [[ ! -f "$(bst_config__config_file)" ]]; then
    mkdir -p "${BST__CONFIG_DIR}"
    system__print_line "$(_bst_config__config_file_header)" > "$(bst_config__config_file)"
  fi
}

function _bst_config__config_file_header() {
  system__print "\
#
# Beastmaster config file
#
# Declare one project per line, ex:
#
# name:directory:tag1:tag2:...:tagN
#"
}

function bst_config__project_lines() {
  local line
  while read line; do
    bst_config__project_line_is_commented "${line}" || system__print_line "${line}"
  done < "$(bst_config__config_file)"
}

function bst_config__project_line_is_commented() {
  [[ "$1" == \#* ]]
}

function bst_config__config_file() {
  system__print "${BST__CONFIG_DIR}/config"
}

