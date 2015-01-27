function program__run() {
  (( $# == 0 )) && _program__print_usage_and_exit_normally
  _program__parse_arguments "$@"
}

function _program__parse_arguments() {
  local argument
  for argument in "$@"; do
    case "${argument}" in
      -h|--help)
      _program__print_usage_and_exit_normally
      ;;
      -*|--*)
      _program__print_illegal_option_and_fail "${argument}"
      ;;
      *)
      shift 1
      _program__run_command "${argument}" "$@"
    esac
  done
}

function _program__run_command() {
  local command="$1"
  shift 1
  type "${command}_command__run" > /dev/null 2>&1 || _program__print_illegal_command_and_fail "${command}"
  ${command}_command__run "$@"
  exit 0
}

function _program__print_illegal_command_and_fail() {
  echo "bst: illegal command -- $1"
  echo ""
  _program__print_usage
  exit 1
}

function _program__print_usage_and_exit_normally() {
  _program__print_usage
  exit 0
}

function _program__print_illegal_option_and_fail() {
  local option="${1%=*}"
  option="${option#-}"
  option="${option#-}"
  echo "bst: illegal option -- ${option}"
  echo ""
  _program__print_usage
  exit 1
}

function _program__print_usage() {
  echo "\
Usage: bst COMMAND [arg...]

A Bash tool which can run any command in your favorite projects.

Options:
  -h, --help  Print usage

Commands:
  config  Edit the configuration
  free    Remove a project from the project list
  list    Print the project list
  order   Execute a command in the project directory
  tame    Add a project to the project list

Run 'bst COMMAND --help' for more information on a command."
}
