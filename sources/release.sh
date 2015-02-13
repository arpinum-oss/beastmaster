_RELEASED_ARTIFACT_FILENAME='bst'
_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd)"
_SOURCES_DIR="${_ROOT_DIR}/sources"
_RELEASE_DIR="${_ROOT_DIR}/releases"
_ORDERED_MODULES_FILE="${_ROOT_DIR}/resources/ordered_modules.txt"

bst_release__concatenate_sources_in_release_file() {
  _bst_release__initialise
  _bst_release__concatenate_sources_in_release_file
  _bst_release__append_program_run_in_release_file
  _bst_release__make_release_file_executable
}

_bst_release__initialise() {
  _bst_release__delete_release_file_if_existing
  mkdir -p "${_RELEASE_DIR}"
}

_bst_release__delete_release_file_if_existing() {
  if [[ -f "$(bst_release__get_released_artifact_file)" ]]; then
    rm "$(bst_release__get_released_artifact_file)"
  fi
}

_bst_release__concatenate_sources_in_release_file() {
  bst_release__execute_for_each_module _bst_release__append_module_to_release_file
}

bst_release__execute_for_each_module() {
  local module_path
  while read module_path; do
    "$@"
  done < "${_ORDERED_MODULES_FILE}"
}

_bst_release__append_program_run_in_release_file() {
  _bst_release__append_to_release_file '[[ "$0" == "${BASH_SOURCE[0]}" ]] && bst_program__run "$@" || true'
}

_bst_release__append_module_to_release_file() {
  _bst_release__append_file_to_release_file "${_SOURCES_DIR}/${module_path}.sh"
}

_bst_release__append_file_to_release_file() {
  cat "$1" >> "$(bst_release__get_released_artifact_file)"
  _bst_release__append_to_release_file "\n\n"
}

_bst_release__make_release_file_executable() {
  chmod +x "$(bst_release__get_released_artifact_file)"
}

_bst_release__append_to_release_file() {
  printf "$1" >> "$(bst_release__get_released_artifact_file)"
}

bst_release__get_released_artifact_file() {
  printf "${_RELEASE_DIR}/${_RELEASED_ARTIFACT_FILENAME}"
}
