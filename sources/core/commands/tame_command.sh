bst_tame_command__parse_args() {
  command__define_current_command "tame"
  command__with_option "d:directory:string:bst_taming_dir"
  command__with_option "r:root:none:bst_taming_root"
  command__with_option "t:tags:string:bst_taming_tags"
  command__parse_args "$@"
}

_bst_tame_command__run() {
  _bst_tame_command_init_taming_dir
  if [[ -n "${bst_taming_root}" ]]; then
    _bst_tame_command__try_add_all_child_projects_in_directory "$@"
  else
    _bst_tame_command__try_add_the_project_in_directory "$@"
  fi
}

_bst_tame_command_init_taming_dir() {
  if [[ -n "${bst_taming_dir}" ]]; then
    bst_taming_dir="$(system__dir_path "${bst_taming_dir}")"
  else
    bst_taming_dir="$(pwd)"
  fi
}

_bst_tame_command__try_add_all_child_projects_in_directory() {
  if (( $# > 0 )); then
    command__bad_usage "bst tame: you should not tame root directory and provide a name."
  else
    local entry
    for entry in ${bst_taming_dir}/*; do
      if [[ -d "${entry}" ]]; then
        _bst_tame_command__add_project "$(system__dir_name "${entry}")" "$(system__dir_path "${entry}")"
      fi
    done
  fi
}

_bst_tame_command__try_add_the_project_in_directory() {
  if (( $# == 0 )); then
    _bst_tame_command__add_project "$(system__dir_name "${bst_taming_dir}")" "${bst_taming_dir}"
  else
    command__check_args_count 1 $#
    _bst_tame_command__add_project "$1" "${bst_taming_dir}"
  fi
}

_bst_tame_command__add_project() {
  local name="$1"
  local directory="$2"
  _bst_tame_command__check_if_project_can_be_tamed "${name}" "${directory}" || return 0
  system__ask_for_confirmation "Tame ${directory} as ${name}?" || return 0
  local line="${name}:${directory}"
  line="$(_bst_tame_command__line_with_tags "${line}")"
  system__print_line "${line}" >> "$(bst_config__config_file)"
  system__print_line "${name} is now tamed!"
}

_bst_tame_command__line_with_tags() {
  local line="$1"
  local tag
  while read tag; do
    line="${line}:${tag}"
  done < <(string__split "${bst_taming_tags}")
  system__print "${line}"
}

_bst_tame_command__check_if_project_can_be_tamed() {
  local name="$1"
  local directory="$2"
  _bst_tame_command__check_name_collision "${name}" || return 1
  _bst_tame_command__check_if_name_contains_reserved_characters "${name}" || return 1
  _bst_tame_command__check_if_a_tag_contains_reserved_characters || return 1
  _bst_tame_command__check_directory_collision "${directory}" || return 1
  return 0
}

_bst_tame_command__check_name_collision() {
  bst_projects__exists_with_name "$1" && \
    system__print_line "A project named $1 already exists so project won't be tamed." && \
    return 1
  return 0  
}

_bst_tame_command__check_if_name_contains_reserved_characters() {
  [[ "$1" == *:* ]] && \
    system__print_line "The project name contains a colon which is forbidden so project won't be tamed." && \
    return 1
  return 0
}

_bst_tame_command__check_if_a_tag_contains_reserved_characters() {
  local tag
  while read tag; do
    [[ "${tag}" == *:* ]] && \
      system__print_line "A tag contains a colon which is forbidden so project won't be tamed." && \
      return 1
  done < <(string__split "${bst_taming_tags}")
  return 0
}

_bst_tame_command__check_directory_collision() {
  bst_projects__exists_with_directory "$1" && \
    system__print_line "A project already exists at directory $1 so project won't be tamed." && \
    return 1
  return 0
}

_bst_tame_command__usage() {
  system__print "\
Add one or more projects to the project list.

Usage: bst tame [options] [project_name]
             -> add single project
   or: bst tame [options] --root
             -> add all projects in the taming directory

Options:
  -d, --directory dir             Set taming directory (default is current).
  -r, --root                      Tame all child projects in the current directory.
  -t, --tags tag1[,tag2][,tagN]   Assign one or more tags to the project.

When directory is not set, the current one is considered as the taming directory."
}
