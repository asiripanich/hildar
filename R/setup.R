#' Save HILDA Stata files data to fst data
#'
#' This function looks in a directory for HILDA data files with `.dta`,
#' the Stata binary data format, save them as fst files.
#' The fst files will be used by `hil_fetch()` for loading HILDA data.
#'
#' @param read_dir read directory where the HILDA files that
#'  match this `Combined_.*.dta` regex pattern are in.
#' @param save_dir a directory to save HILDA files in 'fst' format.
#'  This directory will be added to .Rprofile as `hildar.vault`.
#'
#' @note
#' This function can take a long time to finish since each HILDA file
#' is quite large. One option is to use the future package to choose
#' your parallel backend before running `hil_fetch()`. The following
#' code chuck uses `multisession` which creates background R sessions
#' equal to the number of `workers`.
#'
#' ```
#' library(future)
#' plan(multisession, workers = 2)
#' ```
#'
#' @importFrom parallel detectCores
#' @importFrom readstata13 read.dta13
#' @importFrom fst write.fst
#'
#' @return NULL
#' @export
hil_setup <- function(read_dir, save_dir) {
  checkmate::assert_directory_exists(read_dir, access = "r")
  checkmate::assert_directory_exists(save_dir, access = "rw")
  hilda_filedirs <- list.files(
    path = read_dir,
    pattern = "Combined_.*.dta",
    full.names = TRUE
  )
  hilda_files <- list.files(path = read_dir, pattern = ".dta")
  furrr::future_walk(seq_along(hilda_files), ~ {
    cli::cli_alert_info("Reading a HILDA wave from: {hilda_filedirs[.x]}")
    df <- read.dta13(hilda_filedirs[.x], convert.factors = T, convert.dates = T) %>%
      standardise_hilda_colnames()
    filename <- gsub(pattern = ".dta", replacement = "", hilda_files[.x])
    cli::cli_alert_info("Saving the HILDA file as a fst file.")
    write.fst(df, path = paste0(save_dir, "/", filename, ".fst"))
  })
  cli::cli_alert_success(
    "HILDA fst files have been saved to '{save_dir}'.
      Please add -> {.emph 'HILDA_FST={fs::path_expand(save_dir)}'} \\
      to your .Renviron file or .Rprofile file.
      You can use `usethis::edit_r_profile()` \\
      or `usethis::edit_r_environ()` to open them."
  )

  # make a data dictionary
  make_dict(read_dir, save_dir)

  invisible()
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
    "0.1.0",
    "hildar::setup_hildar()",
    "hildar::hil_setup()"
  )

  warning(
    "`n_cores` and `pattern` are no longer used by ",
    "`hildar::hil_setup()`. See the Note section in ",
    "`?hildar::hil_setup()`."
  )

  hil_setup(read_dir, save_dir)
}
