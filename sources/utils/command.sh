command__parse_args() {
  _command__parse_arguments "$@"
  $(_namespace)run "$@"
}

command__define_current_command() {
  bst_current_command="$1"
  bst_delegate_to_sub_commands="no"
}

command__delegate_to_sub_commands() {
  bst_delegate_to_sub_commands="yes"
}

command__check_args_count() {
  local expected=$1
  local actual=$2
  (( ${actual} > ${expected} )) && _command__wrong_args_count ${actual} ${expected}
}

_command__parse_arguments() {
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
      [[ "${bst_delegate_to_sub_commands}" == "yes" ]] && return
      ;;
    esac
  done
}

command__help_triggered() {
  _command__print_usage
  exit 0
}

_command__illegal_option_parsed() {
  local option="${1%=*}"
  option="${option#-}"
  option="${option#-}"
  system__print_line "$(_command__name): illegal option -- ${option}"
  system__print_new_line
  _command__print_usage
  exit 1
}

_command__wrong_args_count() {
  system__print_line "$(_command__name): wrong args count -- $1 instead of $2 at most"
  system__print_new_line
  _command__print_usage
  exit 1
}

command__illegal_command_parsed() {
  system__print_line "$(_command__name): illegal command -- $1"
  system__print_new_line
  _command__print_usage
  exit 1
}

_command__print_usage() {
  system__print_line "$($(_namespace)usage)"
}

_command__name() {
  [[ "${bst_current_command}" == "default" ]] \
    && system__print "bst" \
    || system__print "bst ${bst_current_command}"
}

_namespace() {
  system__print "_bst_${bst_current_command}_command__"
}
