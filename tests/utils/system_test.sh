should_print(){
  assertion__equal "message" "$(system__print "message")"
}

should_print_special_characters_safely(){
  assertion__equal "%s" "$(system__print "%s")"
}

should_print_line_with_special_characters_safely(){
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

should_print_array() {
  local array=("a" "123" "hello")

  local string="$(system__print_array "${array[@]}")"

  local expected="a
123
hello"
  assertion__equal "${expected}" "${string}"
}

should_print_all_string_array_values() {
  local string_array="a b,c,d"

  local actual="$(system__string_array_values "${string_array}")"

  local expected="a b
c
d"
  assertion__equal "${expected}" "${actual}"
}

