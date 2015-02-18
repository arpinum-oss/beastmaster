bst_config_command__parse_args() {
  command__define_current_command "config"
  command__parse_args "$@"
}

_bst_config_command__run() {
  command__check_args_count 0 $#
  _bst_config_command__check_editor
  "${EDITOR}" "$(bst_config__config_file)"
}

_bst_config_command__check_editor() {
  if [[ -z "${EDITOR}" ]]; then
    system__print_line "EDITOR environment variable must be set."
    system__print_line "  ex: export EDITOR=/usr/bin/nano (or vi if you like 50 shades of grey)"
    exit 1
  fi
}

_bst_config_command__usage() {
  system__print "\
Edit the configuration.

Usage: bst config"
}
