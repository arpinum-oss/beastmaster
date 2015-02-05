function bst_program__run() {
  bst_config__load
  (( $# == 0 )) && _bst_program__print_usage_and_exit_normally
  _bst_program__parse_arguments "$@"
}

function _bst_program__parse_arguments() {
  local argument
  for argument in "$@"; do
    case "${argument}" in
      -h|--help)
      _bst_program__print_usage_and_exit_normally
      ;;
      -*|--*)
      _bst_program__print_illegal_option_and_fail "${argument}"
      ;;
      *)
      shift 1
      _bst_program__run_command "${argument}" "$@"
    esac
  done
}

function _bst_program__run_command() {
  local command="$1"
  shift 1
  local command_function="bst_${command}_command__run"
  type "${command_function}" > /dev/null 2>&1 || _bst_program__print_illegal_command_and_fail "${command}"
  ${command_function} "$@"
  exit 0
}

function _bst_program__print_illegal_command_and_fail() {
  echo "bst: illegal command -- $1"
  echo ""
  _bst_program__print_usage
  exit 1
}

function _bst_program__print_usage_and_exit_normally() {
  _bst_program__print_usage
  exit 0
}

function _bst_program__print_illegal_option_and_fail() {
  local option="${1%=*}"
  option="${option#-}"
  option="${option#-}"
  echo "bst: illegal option -- ${option}"
  echo ""
  _bst_program__print_usage
  exit 1
}

function _bst_program__print_usage() {
  echo "\
Usage: bst <command> [arg...]

A Bash tool which can run any command in your favorite projects.

Options:
  -h, --help  Print usage

Commands:
  config  Edit the configuration
  free    Remove a project from the project list
  list    Print the project list
  order   Execute a command in the project directory
  tame    Add a project to the project list

Run 'bst <command> --help' for more information on a command."
}
