#' Get the `HILDA_FST` environment variable
#'
#' This returns an environment variable called `HILDA_FST` which is
#' the pathname where HILDA fst files are stored.
#'
#' @return a pathname.
#' @export
get_hilda_fst_path <- function() {
  if (is.null(Sys.getenv("HILDA_FST"))) {
    stop("`HILDA_FST` doesn't exist.")
  }
  return(Sys.getenv("HILDA_FST"))
}
