#' @export
#' @rdname hil_vars
hil_labs <- function(pattern, hilda_fst_dir = NULL, ...) {
  checkmate::assert_string(pattern)
  hilda_fst_dir <- hilda_fst_dir %||% get_hilda_fst_dir()
  labs_in_dict <- hil_dict(hilda_fst_dir = hilda_fst_dir)[, label]
  vars_in_dict <- hil_dict(hilda_fst_dir = hilda_fst_dir)[, var]
  vars_in_dict[grepl(pattern = pattern, x = labs_in_dict, ...)]
}
