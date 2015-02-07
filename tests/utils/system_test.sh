function can_print(){
  assertion__equal "message" "$(system__print "message")"
}

function can_print_special_characters_safely(){
  assertion__equal "%s" "$(system__print "%s")"
}

function can_print_line_with_special_characters_safely(){
  assertion__equal "%s" "$(system__print_line "%s")"
}

function a_contained_value_is_contained_by_the_array() {
  local array=("a" "the element" "c")

  assertion__successful system__array_contains "the element" "${array[@]}"
}

function a_not_contained_value_is_not_contained_by_the_array() {
  local array=("a" "the element" "c")

  assertion__failing system__array_contains "the" "${array[@]}"
}
