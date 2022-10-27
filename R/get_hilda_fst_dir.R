#' Get the directory where HILDA fst files are stored.
#'
#' This function looks for `HILDA_FST` in global options and
#' the `.Renviron` file, in this order, and returns the first
#' one it finds.
#'
#' @return a directory.
#' @export
#' @examples 
#' get_hilda_fst_dir()
get_hilda_fst_dir <- function() {
  hil_fst_path <- getOption("HILDA_FST") %||% 
    Sys.getenv("HILDA_FST")
  if (!checkmate::test_directory_exists(hil_fst_path)) {
    stop("The `HILDA_FST` variable doesn't exist in your `.Renviron`, `.Rprofile`, or R global options.")
  }
  return(hil_fst_path)
}
