should_get_name_from_short_option() {
  assertion__equal "t" "$(option__name "-t")"
}

should_get_name_from_long_option() {
  assertion__equal "tada" "$(option__name "--tada")"
}

should_get_name_from_short_option_with_value() {
  assertion__equal "t=3" "$(option__name "-t=3")"
}

should_get_name_from_short_option_with_value() {
  assertion__equal "tada" "$(option__name "--tada=3")"
}

should_get_value_from_short_option() {
  assertion__equal "3" "$(option__value "-t=3")"
}

should_get_yes_value_from_short_option_without_value() {
  assertion__equal "yes" "$(option__value "-t")"
}

should_get_value_from_long_option() {
  assertion__equal "3" "$(option__value "--tada=3")"
}

should_get_yes_value_from_long_option_without_value() {
  assertion__equal "yes" "$(option__value "--tada")"
}

should_get_short_option_from_option_string() {
  assertion__equal "t" "$(option__short_option_from_string "t:tags:variable")"
}

should_get_long_option_from_option_string() {
  assertion__equal "tags" "$(option__long_option_from_string "t:tags:variable")"
}

should_get_value_variable_from_option_string() {
  assertion__equal "variable" "$(option__variable_from_string "t:tags:variable")"
}
