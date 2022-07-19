#' Get the directory where HILDA fst files are stored.
#'
#' This function looks for `HILDA_FST` in global options and
#' the `.Renviron` file, in this order, and returns the first
#' one it finds.
#'
#' @return a directory.
#' @export
#' get_hilda_fst_path()
get_hilda_fst_path <- function() {
  if (!is.null(getOption("HILDA_FST"))) {
    return(getOption("HILDA_FST"))
  }
  if (is.null(Sys.getenv("HILDA_FST"))) {
    stop("`HILDA_FST` doesn't exist.")
  }
  return(Sys.getenv("HILDA_FST"))
}
