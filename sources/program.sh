bst_program__run() {
  bst_config__load
  command__define_current_command "default"
  command__delegate_to_sub_commands
  command__parse_args "$@"
}

_bst_default_command__run() {
  (( $# == 0 )) && command__help_triggered
  _bst_default_command__run_command "$@"
}

_bst_default_command__run_command() {
  local command="$1"
  local accepted=("config" "free" "list" "order" "update" "tame")
  array__contains "${command}" "${accepted[@]}" || command__illegal_command_parsed "${command}"
  shift 1
  bst_${command}_command__parse_args "$@"
}

_bst_default_command__usage() {
  system__print "\
Usage: bst command [arg...]

Beastmaster is a Bash tool which can run any command in your favorite projects
(aka pets).

Options:
  -h, --help  Print usage

Commands:
  config      Edit the configuration
  free        Remove a project from your project list
  list        Print your project list
  order       Execute a command in the project directory
  update      Download and update beastmaster
  tame        Add a project to your project list

Run 'bst command --help' for more information on a command.

Build date: ${BST_BUILD_DATE}"
}
