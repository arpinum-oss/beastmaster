function setup() {
  NAME_AND_DIR="cool_name:cool_directory"
  WITH_TAGS="cool_name:cool_directory:first_tag:second_tag"
}

function can_get_name_from_project_line() {
  local name="$(bst_project__name_from_line "${NAME_AND_DIR}")"

  assertion__equal "cool_name" "${name}"
}

function can_get_name_from_project_line_with_tags() {
  local name="$(bst_project__name_from_line "${WITH_TAGS}")"

  assertion__equal "cool_name" "${name}"
}

function can_get_directory_from_project_line() {
  local directory="$(bst_project__directory_from_line "${NAME_AND_DIR}")"

  assertion__equal "cool_directory" "${directory}"
}

function can_get_directory_from_project_line_with_tags() {
  local directory="$(bst_project__directory_from_line "${WITH_TAGS}")"

  assertion__equal "cool_directory" "${directory}"
}

function can_get_no_tag_if_there_are_none() {
  local tags="$(bst_project__tags_from_line "${NAME_AND_DIR}")"

  assertion__equal "" "${tags}"
}

function can_get_tags_from_project_line() {
  local name="$(bst_project__tags_from_line "${WITH_TAGS}")"

  assertion__equal "$(system__print_line first_tag; system__print_line second_tag)" "${name}"
}
