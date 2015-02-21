setup() {
  test_option="not set"
  test_array=()
  run_called="not set"
  run_called_with=()
  command__define_current_command "test"
  message=""
}

should_parse_short_option_with_value() {
  command__with_option "s:short:string:test_option"

  command__parse_args -s plop

  assertion__status_code_is_success $?
  assertion__equal "plop" "${test_option}"
}

should_fail_if_option_must_have_value_but_no_value_is_provided() {
  command__with_option "s:short:string:test_option"

  message="$(command__parse_args -s)"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "Missing value for option: s"
  assertion__string_contains "${message}" "Test usage"
}

# todo
_should_parse_option_with_values() {
  command__with_option "s:short:array:test_array"

  command__parse_args -s a,b,"hello world"

  assertion__status_code_is_success $?
  assertion__equal 3 ${#test_array[@]}
  assertion__equal "a" ${test_array[0]}
  assertion__equal "b" ${test_array[1]}
  assertion__equal "hello world" ${test_array[2]}
}

should_fail_if_option_is_illegal() {
  message="$(command__parse_args -s)"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "Illegal option: s"
  assertion__string_contains "${message}" "Test usage"
}

should_parse_option_without_value() {
  command__with_option "s:short:none:test_option"

  command__parse_args -s i_am_an_arg

  assertion__status_code_is_success $?
  assertion__equal "yes" "${test_option}"
}

should_parse_long_option() {
  command__with_option "l:long:string:test_option"

  command__parse_args --long plop

  assertion__status_code_is_success $?
  assertion__equal "plop" "${test_option}"
}

should_parse_options_and_run_command_with_remaining_args() {
  command__with_option "a:aa:none:test_option"
  command__with_option "b:bb:none:test_option"

  command__parse_args -a -b "hello" "world"

  assertion__status_code_is_success $?
  assertion__equal "yes" "${run_called}"
  assertion__equal 2 ${#run_called_with[@]}
  assertion__equal "hello" "${run_called_with[0]}"
  assertion__equal "world" "${run_called_with[1]}"
}

should_parse_options_with_values_and_run_command_with_remaining_args() {
  command__with_option "a:aa:string:test_option"
  command__with_option "b:bb:string:test_option"

  command__parse_args -a a -b b "hello" "world"

  assertion__status_code_is_success $?
  assertion__equal "yes" "${run_called}"
  assertion__equal 2 ${#run_called_with[@]}
  assertion__equal "hello" "${run_called_with[0]}"
  assertion__equal "world" "${run_called_with[1]}"
}

should_stop_parsing_options_at_the_first_non_option_arg() {
  command__with_option "a:aa:none:test_option"
  command__with_option "b:bb:none:test_option"

  command__parse_args -a "hello" -b

  assertion__status_code_is_success $?
  assertion__equal "yes" "${run_called}"
  assertion__equal 2 ${#run_called_with[@]}
  assertion__equal "hello" "${run_called_with[0]}"
  assertion__equal "-b" "${run_called_with[1]}"
}

_bst_test_command__run() {
  run_called="yes"
  run_called_with=("$@")
}

_bst_test_command__usage() {
  echo "Test usage"
}
