function command__help_triggered() {
  _command__print_usage
  exit 0
}

function command__illegal_option_parsed() {
  local option="${1%=*}"
  option="${option#-}"
  option="${option#-}"
  system__print_line "$(_command__name): illegal option -- ${option}"
  system__print_new_line
  _command__print_usage
  exit 1
}

function command__illegal_command_parsed() {
  system__print_line "$(_command__name): illegal command -- $1"
  system__print_new_line
  _command__print_usage
  exit 1
}

function _command__print_usage() {
  system__print_line "$(_bst_${BST__CURRENT_COMMAND}_command__usage)"
}

function _command__name() {
  [[ "${BST__CURRENT_COMMAND}" == "default" ]] \
    && system__print "bst" \
    || system__print "bst ${BST__CURRENT_COMMAND}"
}
