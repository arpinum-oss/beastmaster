command__parse_args() {
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
  for (( bst_read_options = 0; bst_read_options < $#; )) do
    local index=$(( bst_read_options + 1 ))
    local argument="${!index}"
    case "${argument}" in
      -h|--help)
      command__help_triggered
      ;;
      --*)
      _command__handle_long_option "${argument}" "${@:${index}+1}"
      ;;
      -*)
      _command__handle_short_option "${argument}" "${@:${index}+1}"
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
  _command__handle_option "short" "$@"
}

_command__handle_long_option() {
  _command__handle_option "long" "$@"
}

_command__handle_option() {
  local option_length="$1"
  local option_with_dash="$2"
  shift 2
  (( bst_read_options++ ))
  local option_name="$(option__name "${option_with_dash}")"
  local option_string
  for option_string in "${bst_option_strings[@]}"; do
    if [[ "${option_name}" == "$(option__"${option_length}"_option_from_string "${option_string}")" ]]; then
      local option_variable="$(option__variable_from_string "${option_string}")"
      local option_value_type="$(option__value_type_from_string "${option_string}")"
      if [[ "${option_value_type}" != "none" ]]; then
        (( bst_read_options++ ))
        _command__check_if_option_is_followed_by_value "${option_name}" "$@"
        local option_value="$1"
      else
        local option_value="yes"
      fi
      printf -v "${option_variable}" "${option_value}"
      return 0
    fi
  done
  _command__illegal_option_parsed "${option_name}"
}

_command__illegal_option_parsed() {
  system__print_line "Illegal option: $1"
  system__print_new_line
  _command__print_usage
  exit 1
}

_command__check_if_option_is_followed_by_value() {
  if (( $# == 1 )); then
    system__print_line "Missing value for option: $1"
    system__print_new_line
    _command__print_usage
    exit 1
  fi
}

_command__wrong_args_count() {
  command__bad_usage "Wrong args count: $1 instead of $2 at most"
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
  system__print_line "Illegal command: $1"
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
