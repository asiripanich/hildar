#' Search HILDA data dictionary by variable or label.
#'
#' @param pattern a RegEx pattern.
#' @template hilda_fst_dir
#' @param ... arguments here are passed to `grepl()`.3
#'
#' @return a character vector of variable names that match the pattern.
#' @export
hil_vars <- function(pattern, hilda_fst_dir = NULL, ...) {
  checkmate::assert_string(pattern)
  hilda_fst_dir <- hilda_fst_dir %||% get_hilda_fst_dir()
  vars_in_dict <- hil_dict(hilda_fst_dir = hilda_fst_dir)[, var]
  vars_in_dict[grepl(pattern = pattern, x = vars_in_dict, ...)]
}

