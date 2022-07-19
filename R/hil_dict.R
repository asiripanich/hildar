#' @rdname hil_setup
#' @export
#' @examples
#' # HILDA data dictionary
#' \dontrun{
#' hil_dict()
#' }
hil_dict <- function() {
  hilda_dict_path <- fs::path(get_hilda_fst_path(), "hil_dict.rds")
  checkmate::assert_file_exists(hilda_dict_path)
  readRDS(hilda_dict_path)
}