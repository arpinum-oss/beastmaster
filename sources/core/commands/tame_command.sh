bst_tame_command__parse_args() {
  command__define_current_command "tame"
  command__with_option "d:directory:bst_taming_dir"
  command__with_option "r:root:bst_taming_root"
  command__with_option "t:tags:bst_taming_tags"
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
  while read tag; do
    line="${line}:${tag}"
  done < <(string__split "${bst_taming_tags}")
  system__print "${line}"
}

_bst_tame_command__check_project_collisions() {
  local name="$1"
  local directory="$2"
  bst_projects__exists_with_name "${name}" && _bst_tame_command__name_collision "${name}"
  bst_projects__exists_with_directory "${directory}" && _bst_tame_command__directory_collision "${directory}"
}

_bst_tame_command__name_collision() {
  command__fail "A project named $1 already exists."
}

_bst_tame_command__directory_collision() {
  command__fail "A project already exists at directory $1."
}

_bst_tame_command__usage() {
  system__print "\
Add one or more projects to the project list.

Usage: bst tame [options] [project_name]
             -> add single project
   or: bst tame [options] --root
             -> add all projects in the taming directory

Options:
  -d, --directory                 Set taming directory (default is current).
  -r, --root                      Tame all child projects in the current directory.
  -t, --tags=tag1[,tag2][,tagN]   Assign one or more tags to the project.

When directory is not set, the current one is considered as the taming directory."
}
