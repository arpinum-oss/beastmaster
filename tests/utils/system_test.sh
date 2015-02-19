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

  assertion__successful array__contains "the element" "${array[@]}"
}

a_not_contained_value_is_not_contained_by_the_array() {
  local array=("a" "the element" "c")

  assertion__failing array__contains "the" "${array[@]}"
}

should_print_array() {
  local array=("a" "123" "hello")

  local string="$(array__print "${array[@]}")"

  local expected="a
123
hello"
  assertion__equal "${expected}" "${string}"
}

should_print_all_string_array_values() {
  local string_array="a b,c,d"

  local actual="$(string__split "${string_array}")"

  local expected="a b
c
d"
  assertion__equal "${expected}" "${actual}"
}

