should_get_token_at_given_position() {
  assertion__equal "hello" "$(string__token_at 1 "hello:world:!")"
  assertion__equal "world" "$(string__token_at 2 "hello:world:!")"
  assertion__equal "!" "$(string__token_at 3 "hello:world:!")"
}

should_get_all_but_first_token() {
  assertion__equal "world:!" "$(string__without_first_token "hello:world:!")"
}
