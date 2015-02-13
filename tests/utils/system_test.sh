can_print(){
  assertion__equal "message" "$(system__print "message")"
}

can_print_special_characters_safely(){
  assertion__equal "%s" "$(system__print "%s")"
}

can_print_line_with_special_characters_safely(){
  assertion__equal "%s" "$(system__print_line "%s")"
}

a_contained_value_is_contained_by_the_array() {
  local array=("a" "the element" "c")

  assertion__successful system__array_contains "the element" "${array[@]}"
}

a_not_contained_value_is_not_contained_by_the_array() {
  local array=("a" "the element" "c")

  assertion__failing system__array_contains "the" "${array[@]}"
}

can_print_array() {
  local array=("a" "123" "hello")

  local string="$(system__print_array "${array[@]}")"

  local expected="a
123
hello"
  assertion__equal "${expected}" "${string}"
}
