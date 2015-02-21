should_get_short_option_name() {
  assertion__equal "s" "$(option__name "-s")"
}

should_get_long_option_name() {
  assertion__equal "long" "$(option__name "--long")"
}

should_get_value_type_from_option_string() {
  assertion__equal "string" "$(option__value_type_from_string "t:tags:string:variable")"
}

should_get_short_option_from_option_string() {
  assertion__equal "t" "$(option__short_option_from_string "t:tags:none:variable")"
}

should_get_long_option_from_option_string() {
  assertion__equal "tags" "$(option__long_option_from_string "t:tags:none:variable")"
}

should_get_value_variable_from_option_string() {
  assertion__equal "variable" "$(option__variable_from_string "t:tags:none:variable")"
}
