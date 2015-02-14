bst_tame_command__parse_args() {
  BST_TAMING_TAGS=()
  command__define_current_command "tame"
  command__with_valid_option "tags"
  command__parse_args "$@"
}

_bst_tame_command__option_set() {
  BST_TAMING_TAGS=(${2//${BST_VALUE_SEPARATOR}/ })
}

_bst_tame_command__run() {
  local directory="$(pwd)"
  if (( $# == 0 )); then
    _bst_tame_command__add_project "${directory##*\/}" "${directory}"
  else
    command__check_args_count 1 $#
    _bst_tame_command__add_project "$1" "${directory}"
  fi
}

_bst_tame_command__add_project() {
  local name="$1"
  local directory="$2"
  _bst_tame_command__check_project_collisions "${name}" "${directory}"
  local line="${name}:${directory}"
  line="$(_bst_tame_command__line_with_tags "${line}")"
  system__print_line "${line}" >> "$(bst_config__config_file)"
}

_bst_tame_command__line_with_tags() {
  local line="$1"
  local tag
  for tag in ${BST_TAMING_TAGS[@]}; do
    line="${line}:${tag}"
  done
  system__print "${line}"
}

_bst_tame_command__check_project_collisions() {
  local name="$1"
  local directory="$2"
  local line
  for line in $(bst_config__project_lines); do
    local current_name="$(bst_project__name_from_line "${line}")"
    local current_dir="$(bst_project__directory_from_line "${line}")"
    [[ "${name}" == "${current_name}" ]] && _bst_tame_command__name_collision "${name}"
    [[ "${directory}" == "${current_dir}" ]] && _bst_tame_command__directory_collision "${directory}"
  done
}

_bst_tame_command__name_collision() {
  system__print_line "The project cannot be tamed: name $1 already exists."
  exit 1
}

_bst_tame_command__directory_collision() {
  system__print_line "The project cannot be tamed: directory $1 already exists."
  exit 1
}

_bst_tame_command__usage() {
  system__print "\
Usage: bst tame [project_name] [options]

Options:
  -t, --tags=tag1[,tag2][,tagN]   Assign one or more tags to the project
  -h, --help                      Print usage

Add a project to your project list."
}
