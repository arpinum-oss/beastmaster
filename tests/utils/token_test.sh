should_get_token_at_given_position() {
  assertion__equal "hello" "$(token__at 1 "hello:world:!")"
  assertion__equal "world" "$(token__at 2 "hello:world:!")"
  assertion__equal "!" "$(token__at 3 "hello:world:!")"
}

should_get_all_but_first_token() {
  assertion__equal "world:!" "$(token__without_first "hello:world:!")"
}
