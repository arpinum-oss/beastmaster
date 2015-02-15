bst_projects__exists_with_name() {
  local name="$1"
  local line
  while read line; do
    local current_name="$(bst_project__name_from_line "${line}")"
    [[ "${name}" == "${current_name}" ]] && return 0
  done < <(bst_config__project_lines)
  return 1
}

bst_projects__exists_with_directory() {
  local directory="$1"
  local line
  while read line; do
    local current_dir="$(bst_project__directory_from_line "${line}")"
    [[ "${directory}" == "${current_dir}" ]] && return 0
  done < <(bst_config__project_lines)
  return 1
}

bst_projects__for_each_line() {
  local line
  while read line; do
    "$@" "${line}"
  done < <(bst_config__project_lines)
}
