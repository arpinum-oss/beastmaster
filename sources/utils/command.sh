command__parse_args() {
  bst_read_options=0
  _command__parse_options "$@"
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

_command__parse_options() {
  local index
  for (( index = 1; index <= $#; index++ )) do
    local argument="${!index}"
    case "${argument}" in
      -h|--help)
      command__help_triggered
      ;;
      --*)
      (( bst_read_options++ ))
      _command__handle_long_option "${argument}"
      ;;
      -*)
      (( bst_read_options++ ))
      _command__handle_short_option "${argument}"
      ;;
      *)
      return 0
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
  for option_string in "${bst_option_strings[@]}"; do
    if [[ "${option_name}" == "$(option__"${option_length}"_option_from_string "${option_string}")" ]]; then
      local option_variable="$(option__variable_from_string "${option_string}")"
      printf -v "${option_variable}" "$(option__value "${option_with_dash}")"
      return 0
    fi
  done
  _command__illegal_option_parsed "${option_name}"
}

_command__illegal_option_parsed() {
  system__print_line "Illegal option -- $1"
  system__print_new_line
  _command__print_usage
  exit 1
}

_command__wrong_args_count() {
  command__bad_usage "Wrong args count -- $1 instead of $2 at most"
}

command__bad_usage() {
  system__print_line "$1"
  system__print_new_line
  _command__print_usage
  exit 1
}

command__fail() {
  system__print_line "$1"
  exit 1
}

command__illegal_command_parsed() {
  system__print_line "Illegal command -- $1"
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
