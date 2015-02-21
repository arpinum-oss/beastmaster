should_print(){
  assertion__equal "message" "$(system__print "message")"
}

should_print_special_characters_safely(){
  assertion__equal "%s" "$(system__print "%s")"
}

should_print_line_with_special_characters_safely(){
  assertion__equal "%s" "$(system__print_line "%s")"
}

