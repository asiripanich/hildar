#' @rdname hil_setup
#' @export
#' @examples
#' # HILDA data dictionary
#' \dontrun{
#' hil_dict()
#' }
hil_dict <- function(hilda_fst_dir = get_hilda_fst_path()) {
  hilda_dict_path <- fs::path(hilda_fst_dir, "hil_dict.rds")
  checkmate::assert_file_exists(hilda_dict_path)
  readRDS(hilda_dict_path)
}