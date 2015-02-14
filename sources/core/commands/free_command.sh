bst_free_command__parse_args() {
  command__define_current_command "free"
  command__parse_args "$@"
}

_bst_free_command__run() {
  command__check_args_count 1 $#
  local name="$1"
  local new_config="$(_bst_free_command__create_temp_file)"
  local line
  while read line; do
    _bst_free_command__line_must_be_kept "${line}" "${name}" && system__print_line "${line}" >> "${new_config}"
  done < "$(bst_config__config_file)"
  _bst_free_command__copy_temp_file_in_config_file "${new_config}"
}

_bst_free_command__line_must_be_kept() {
  local line="$1"
  local name="$2"
  bst_config__project_line_is_commented "${line}" && return 0
  local current_name="$(bst_project__name_from_line "${line}")"
  [[ "${current_name}" != "${name}" ]]
}

_bst_free_command__create_temp_file() {
  local file="${BST_CONFIG_DIR}/config_${RANDOM}"
  touch "${file}"
  system__print "${file}"
}

_bst_free_command__copy_temp_file_in_config_file() {
  local new_config="$1"
  cat "${new_config}" > "$(bst_config__config_file)"
  rm "${new_config}"
}

_bst_free_command__usage() {
  system__print "\
Usage: bst free <project-name>

Remove a project from your project list."
}
