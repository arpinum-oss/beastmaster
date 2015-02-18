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

bst_projects__reset_filters() {
  bst_project_filter_name=""
  bst_project_filter_tags=()
}

bst_projects__filters_empty() {
  [[ -z "${bst_project_filter_name}" ]] \
    && (( ${#bst_project_filter_tags[@]} == 0 ))
}

bst_projects__filtered_lines() {
  local line
  while read line; do
    _bst_projects__line_satisfies_name_filter "${line}" \
    && _bst_projects__line_satisfies_tags_filter "${line}" \
    && system__print_line "${line}"
  done < <(bst_config__project_lines)
}

_bst_projects__line_satisfies_name_filter() {
  [[ -z "${bst_project_filter_name}" ]] && return 0
  [[ "$(bst_project__name_from_line "$1")" == ${bst_project_filter_name} ]]
}

_bst_projects__line_satisfies_tags_filter() {
  (( ${#bst_project_filter_tags[@]} == 0 )) && return 0
  local wanted_tag
  for wanted_tag in "${bst_project_filter_tags[@]}"; do
    _bst_projects__project_line_has_tag "${line}" "${wanted_tag}" && return 0
  done
  return 1
}

_bst_projects__project_line_has_tag() {
  local line="$1"
  local wanted_tag="$2"
  local line_tag
  while read line_tag; do
    [[ "${line_tag}" == "${wanted_tag}" ]] && return 0
  done < <(bst_project__tags_from_line "${line}")
  return 1
}
