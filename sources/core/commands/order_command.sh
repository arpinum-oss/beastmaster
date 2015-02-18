bst_order_command__parse_args() {
  command__define_current_command "order"
  bst_projects__reset_filters
  command__with_option "v:verbose:bst_verbose_orders"
  command__with_option "n:name:bst_order_name"
  command__with_option "t:tags:bst_order_tags"
  command__parse_args "$@"
}

_bst_order_command__run() {
  (( $# == 0 )) && command__help_triggered
  [[ -n "${bst_order_tags}" ]] && _bst_order_command__init_tags_filter
  [[ -n "${bst_order_name}" ]] && bst_project_filter_name="${bst_order_name}"
  if bst_projects__filters_empty; then
    bst_project_filter_name="$1"
    shift 1
  fi
  _bst_order_command__order_command_for_filtered_projects "$@"
}

_bst_order_command__init_tags_filter() {
  local tag
  while read tag; do
    bst_project_filter_tags+=("${tag}")
  done < <(system__string_array_values "${bst_order_tags}")
}

_bst_order_command__order_command_for_filtered_projects() {
  local line
  while read line; do
    local directory="$(bst_project__directory_from_line "${line}")"
    local name="$(bst_project__name_from_line "${line}")"
    _bst_order_command__check_directory
    _bst_order_command__order_command "$@"
  done < <(bst_projects__filtered_lines)
}

_bst_order_command__order_command() {
  [[ "${bst_verbose_orders}" == "yes" ]] \
    && system__print_line "Ordering command in ${directory} for ${name}."
  ( cd "${directory}" && "$@" )
}

_bst_order_command__check_directory() {
  if [[ ! -d "${directory}" ]]; then
    system__print_line "${directory} does not exist for ${name}."
    exit 1
  fi
}

_bst_order_command__usage() {
  system__print "\
Execute a command in the project directory.

Usages: bst order [options] [project_name] command
    or: bst order --tags=tag1 command
    or: bst order --name=project_name --tags=tag1 command

Options:
  -n, --name=project_name   Only consider projects matching the name.
  -t, --tags=tag1[,tagN]    Only consider projects having one of these tags.
  -v, --verbose             Print more information.

bst order options should be placed before command to not mess with command own
options.

If both tag and name filters must be set, the name should be passed with
--name option to avoid ambiguity with command."
}
