command__parse_args() {
  bst_read_options=0
  _command__parse_arguments "$@"
  shift ${bst_read_options}
  $(_namespace)run "$@"
}

command__define_current_command() {
  bst_current_command="$1"
  bst_delegate_to_sub_commands="no"
  bst_option_strings=()
}

command__delegate_to_sub_commands() {
  bst_delegate_to_sub_commands="yes"
}

command__with_option() {
  bst_option_strings+=("$1")
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
      --*)
      _command__handle_long_option "${argument}"
      ;;
      -*)
      _command__handle_short_option "${argument}"
      ;;
      *)
      [[ "${bst_delegate_to_sub_commands}" == "yes" ]] && return 0
      ;;
    esac
  done
}

command__help_triggered() {
  _command__print_usage
  exit 0
}

_command__handle_short_option() {
  _command__handle_option "$1" "short"
}

_command__handle_long_option() {
  _command__handle_option "$1" "long"
}

_command__handle_option() {
  local option_with_dash="$1"
  local option_length="$2"
  local option_name="$(option__name "${option_with_dash}")"
  local option_string
  for option_string in ${bst_option_strings[@]}; do
    if [[ "${option_name}" == "$(option__"${option_length}"_option_from_string "${option_string}")" ]]; then
      local option_variable="$(option__variable_from_string "${option_string}")"
      eval "${option_variable}"="$(option__value "${option_with_dash}")"
      (( bst_read_options++ ))
      return 0
    fi
  done
  _command__illegal_option_parsed "${option_name}"
}

_command__illegal_option_parsed() {
  system__print_line "$(_command__name): illegal option -- $1"
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
