#' Search HILDA data dictionary by variable or label.
#'
#' @param pattern a RegEx pattern.
#' @param ... arguments here are passed to `grepl()`.3
#'
#' @return a character vector of variable names that match the pattern.
#' @export
hil_vars <- function(pattern, ...) {
  checkmate::assert_string(pattern)
  vars_in_dict <- hil_dict()[, var]
  vars_in_dict[grepl(pattern = pattern, x = vars_in_dict, ...)]
}

