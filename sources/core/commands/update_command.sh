bst_update_command__parse_args() {
  command__define_current_command "update"
  command__parse_args "$@"
}

_bst_update_command__run() {
  command__check_args_count 0 $#
  \curl -sSL "${BST_INSTALL_URL}" | bash -s
}

_bst_update_command__usage() {
  system__print "\
Download and update beastmaster.

Usage: bst update"
}
