should_get_token_at_given_position() {
  assertion__equal "hello" "$(string__token_at 1 "hello:world:!")"
  assertion__equal "world" "$(string__token_at 2 "hello:world:!")"
  assertion__equal "!" "$(string__token_at 3 "hello:world:!")"
}

should_get_all_but_first_token() {
  assertion__equal "world:!" "$(string__without_first_token "hello:world:!")"
}

should_print_all_string_array_values() {
  local string_array="a b,c,d"

  local actual="$(string__split "${string_array}")"

  local expected="a b
c
d"
  assertion__equal "${expected}" "${actual}"
}
