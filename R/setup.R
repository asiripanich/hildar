#' Save HILDA Stata files data to fst data
#'
#' @param read_dir readind directory where the HILDA .dta files are
#' @param save_dir a directory to save HILDA files in 'fst' format. 
#'  This directory will be added to .Rprofile as `hildar.vault`.
#' @param n_cores number of cores
#' @param pattern only reads ".dta" stata files for now
#'
#' @importFrom future plan multiprocess
#' @importFrom parallel detectCores
#' @importFrom readstata13 read.dta13
#' @importFrom fst write.fst
#'
#' @return NULL
#' @export
hil_setup <- function(read_dir, save_dir, n_cores = NULL, pattern = ".dta") {
  checkmate::assert_directory_exists(read_dir, access = "r")
  checkmate::assert_directory_exists(save_dir, access = "rw")
  checkmate::assert_count(n_cores, positive = T, null.ok = T)
  if (is.null(n_cores)) {
    n_cores <- parallel::detectCores() / 2
    message("using ", n_cores, " cores to setup hilda files.")
  }
  future::plan(future::multiprocess, workers = n_cores)
  hilda_filedirs <- list.files(path = read_dir, pattern = pattern, full.names = T)
  hilda_files <- list.files(path = read_dir, pattern = pattern)
  if (file.exists(save_dir)) {
    furrr::future_map(seq_along(hilda_files), ~ {
      df <- read.dta13(hilda_filedirs[.x], convert.factors = T, convert.dates = T) %>%
        standardise_hilda_colnames()
      message("finished reading from ", hilda_filedirs[.x])
      filename <- gsub(pattern = pattern, replacement = "", hilda_files[.x])
      message("writing to fst..")
      write.fst(df, path = paste(save_dir, "/", filename, ".fst", sep = ""))
    })
    message("done")
  } else {
    message("save_dir doesn't exist, no files were created")
  }
}

#' Save HILDA Stata files data to fst data
#' 
#' Soft-deprecated, new code should use [hil_setup()].
#' 
#' @return See [hil_setup()].
#' @importFrom lifecycle deprecate_soft
#' @export
#' @keywords internal
setup_hildar <- function(read_dir, save_dir, n_cores = NULL, pattern = ".dta") {
  lifecycle::deprecate_soft(
    "0.4.0", 
    "mlfit::setup_hildar()", 
    "mlfit::hil_setup()"
  )
  hil_setup(read_dir, save_dir, n_cores, pattern)
}