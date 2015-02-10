function bst_program__run() {
  bst_config__load
  BST__CURRENT_COMMAND="default"
  command__run "$@"
}

function _bst_default_command__with_sub_commands() {
  return 0
}

function _bst_default_command__accepted_commands() {
  system__print_array "config" "free" "list" "order" "tame"
}

function _bst_default_command__run_default() {
  command__help_triggered
}

function _bst_default_command__run_command() {
  local command="$1"
  shift 1
  local command_function="bst_${command}_command__run"
  ${command_function} "$@"
}

function _bst_default_command__usage() {
  system__print "\
Usage: bst <command> [arg...]

A Bash tool which can run any command in your favorite projects (aka pets).

Options:
  -h, --help  Print usage

Commands:
  config  Edit the configuration
  free    Remove a project from your project list
  list    Print your project list
  order   Execute a command in the project directory
  tame    Add a project to your project list

Run 'bst <command> --help' for more information on a command."
}
