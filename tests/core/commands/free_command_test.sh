function should_print_usage_for_help() {
  local message
  message="$(bst_free_command__parse_args "--help")"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "Usage: bst free"
}

function should_fail_for_any_additionnal_argument() {
  local message
  message="$(bst_free_command__parse_args "project" "bleh")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "bst free: wrong args count -- 2 instead of 1"
}

function should_remove_project_from_config() {
  create_config_dir_for_tests
  echo "cool-project:/home/alone/dev/cool-project" > "$(bst_config__config_file)"

  bst_free_command__parse_args "cool-project"

  assertion__status_code_is_success $?
  assertion__equal "" "$(cat "$(bst_config__config_file)")"
}

function should_ignore_comments_when_removing_project() {
  create_config_dir_for_tests
  local line="# cool-project:/home/alone/dev/cool-project"
  echo "${line}" > "$(bst_config__config_file)"

  bst_free_command__parse_args "cool-project"

  assertion__status_code_is_success $?
  assertion__equal "${line}" "$(cat "$(bst_config__config_file)")"
}
