#' Save HILDA Stata files data to fst data
#'
#' @param read_dir readind directory where the HILDA .dta files are
#' @param save_dir saving directory
#' @param cores number of cores
#' @param pattern only reads ".dta" stata files for now
#'
#' @importFrom doMC registerDoMC
#' @importFrom parallel detectCores
#' @importFrom foreach foreach
#' @importFrom readstata13 read.dta13
#' @importFrom fst write.fst
#'
#' @return NULL
#' @export
hilda_to_hildar <- function(read_dir, save_dir, cores = NULL, pattern = ".dta") {
  if (is.null(cores)) cores <- parallel::detectCores() / 2
  registerDoMC(cores)
  hilda_filedirs <- list.files(path = read_dir, pattern = pattern, full.names = T)
  hilda_files <- list.files(path = read_dir, pattern = pattern)
  if (file.exists(save_dir)) {
    foreach::foreach(file_index = seq_along(hilda_files)) %dopar% {
      df <- read.dta13(hilda_filedirs[file_index], convert.factors = T, convert.dates = T) %>%
        standardise_hilda_colnames()
      filename <- gsub(pattern = pattern, replacement = "", hilda_files[file_index])
      write.fst(df, path = paste(save_dir, "/", filename, ".fst", sep = ""))
    }
    message("done")
  } else {
    message("save_dir doesn't exist, no files were created")
  }
}
