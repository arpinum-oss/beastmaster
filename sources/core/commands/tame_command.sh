bst_tame_command__parse_args() {
  command__define_current_command "tame"
  command__with_option "t:tags:bst_taming_tags"
  command__parse_args "$@"
}

_bst_tame_command__run() {
  local directory="$(pwd)"
  if (( $# == 0 )); then
    _bst_tame_command__add_project "$(system__dir_name "${directory}")" "${directory}"
  else
    command__check_args_count 1 $#
    _bst_tame_command__add_project "$1" "${directory}"
  fi
}

_bst_tame_command__add_project() {
  local name="$1"
  local directory="$2"
  _bst_tame_command__check_project_collisions "${name}" "${directory}"
  system__ask_for_confirmation "Tame ${directory} as ${name}?" || return 0
  local line="${name}:${directory}"
  line="$(_bst_tame_command__line_with_tags "${line}")"
  system__print_line "${line}" >> "$(bst_config__config_file)"
  system__print_line "${name} is now tamed!"
}

_bst_tame_command__line_with_tags() {
  local line="$1"
  local tag
  local tags=(${bst_taming_tags//${BST_VALUE_SEPARATOR}/ })
  for tag in ${tags[@]}; do
    line="${line}:${tag}"
  done
  system__print "${line}"
}

_bst_tame_command__check_project_collisions() {
  local name="$1"
  local directory="$2"
  bst_projects__exists_with_name "${name}" && _bst_tame_command__name_collision "${name}"
  bst_projects__exists_with_directory "${directory}" && _bst_tame_command__directory_collision "${directory}"
}

_bst_tame_command__name_collision() {
  system__print_line "A project named $1 already exists."
  exit 1
}

_bst_tame_command__directory_collision() {
  system__print_line "A project already exists at directory $1."
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
