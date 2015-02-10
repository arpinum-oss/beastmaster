function bst_free_command__run() {
  BST__CURRENT_COMMAND="free"
  command__run "$@"
}

function _bst_free_command__with_sub_commands() {
  return 1
}

function _bst_free_command__arguments_count() {
  system__print "1"
}

function _bst_free_command__run_default() {
  local name="$1"
  local new_config="$(_bst_free_command__create_temp_file)"
  local line
  while read line; do
    _bst_free_command__line_must_be_kept "${line}" "${name}" && echo "${line}" >> "${new_config}"
  done < "$(bst_config__config_file)"
  _bst_free_command__copy_temp_file_in_config_file "${new_config}"
}

function _bst_free_command__line_must_be_kept() {
  local line="$1"
  local name="$2"
  bst_config__project_line_is_commented "${line}" && return 0
  local current_name="$(bst_project__name_from_line "${line}")"
  [[ "${current_name}" != "${name}" ]]
}

function _bst_free_command__create_temp_file() {
  local file="${BST__CONFIG_DIR}/config_${RANDOM}"
  touch "${file}"
  system__print "${file}"
}

function _bst_free_command__copy_temp_file_in_config_file() {
  local new_config="$1"
  cat "${new_config}" > "$(bst_config__config_file)"
  rm "${new_config}"
}

function _bst_free_command__usage() {
  system__print "\
Usage: bst free <project-name>

Remove a project from your project list."
}
