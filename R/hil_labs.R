#' @export
#' @rdname hil_vars
hil_labs <- function(pattern, ...) {
  checkmate::assert_string(pattern)
  labs_in_dict <- hil_dict()[, label]
  vars_in_dict <- hil_dict()[, var]
  vars_in_dict[grepl(pattern = pattern, x = labs_in_dict, ...)]
}
