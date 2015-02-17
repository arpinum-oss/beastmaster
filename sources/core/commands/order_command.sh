bst_order_command__parse_args() {
  command__define_current_command "order"
  command__with_option "v:verbose:bst_verbose_orders"
  command__parse_args "$@"
}

_bst_order_command__run() {
  local given_name="$1"
  shift
  local line
  while read line; do
    local directory="$(bst_project__directory_from_line "${line}")"
    local name="$(bst_project__name_from_line "${line}")"
    _bst_order_command__check_directory
    _bst_order_command__order_command "$@"
  done < <(bst_projects__lines_with_name "${given_name}")
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
Usage: bst order [options] [project_name] command

Options:
  -t, --tags=tag1[,tag2][,tagN]   Consider only projects having one of these tags.
  -v, --verbose                   Print more information.

bst order options should be placed before command to not mess with command own options.

Execute a command in the project directory."
}
