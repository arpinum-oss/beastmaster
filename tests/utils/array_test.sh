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
