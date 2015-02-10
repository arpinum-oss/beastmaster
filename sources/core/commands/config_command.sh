function bst_config_command__run() {
  BST__CURRENT_COMMAND="config"
  command__run "$@"
}

function _bst_config_command__with_sub_commands() {
  return 1
}

function _bst_config_command__arguments_count() {
  system__print "0"
}

function _bst_config_command__run_default() {
  _bst_config_command__check_editor
  "${EDITOR}" "$(bst_config__config_file)"
}

function _bst_config_command__check_editor() {
  if [[ -z "${EDITOR}" ]]; then
    system__print_line "EDITOR environment variable must be set."
    system__print_line "  ex: export EDITOR=/usr/bin/nano (or vi if you like 50 shades of grey)"
    exit 1
  fi
}

function _bst_config_command__usage() {
  system__print "\
Usage: bst config

Edit the configuration."
}
