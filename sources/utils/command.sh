function command__run() {
  (( $# == 0 )) && $(_namespace)run_default
  _command__parse_arguments "$@"
}

function _command__parse_arguments() {
  local argument
  for argument in "$@"; do
    case "${argument}" in
      -h|--help)
      command__help_triggered
      ;;
      -*|--*)
      _command__illegal_option_parsed "${argument}"
      ;;
      *)
      _command__check_command "${argument}"
      shift 1
      $(_namespace)run_command "${argument}" "$@"
    esac
  done
}

function _command__check_command() {
  local accepted_commands=($($(_namespace)accepted_commands))
  system__array_contains "$1" "${accepted_commands[@]}"
  (( $? != 0 )) && _command__illegal_command_parsed "$1"
}

function command__help_triggered() {
  _command__print_usage
  exit 0
}

function _command__illegal_option_parsed() {
  local option="${1%=*}"
  option="${option#-}"
  option="${option#-}"
  system__print_line "$(_command__name): illegal option -- ${option}"
  system__print_new_line
  _command__print_usage
  exit 1
}

function _command__illegal_command_parsed() {
  system__print_line "$(_command__name): illegal command -- $1"
  system__print_new_line
  _command__print_usage
  exit 1
}

function _command__print_usage() {
  system__print_line "$($(_namespace)usage)"
}

function _command__name() {
  [[ "${BST__CURRENT_COMMAND}" == "default" ]] \
    && system__print "bst" \
    || system__print "bst ${BST__CURRENT_COMMAND}"
}

function _namespace() {
  system__print "_bst_${BST__CURRENT_COMMAND}_command__"
}
