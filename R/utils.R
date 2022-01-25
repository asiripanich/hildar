#' Remove the leading alphabets of all the columns
#' except those start with 'x'
#' @param hilda_data a data.frame containing a HILDA dataset
#'
#' @return data.table
#' @export
standardise_hilda_colnames <- function(hilda_data) {
  first_chars <- substr(colnames(hilda_data), 1, 1)
  notfirst_chars <- substr(colnames(hilda_data), 2, 1000)
  colnames(hilda_data) <-
    paste(ifelse(first_chars == first_chars[2], "", first_chars),
      notfirst_chars,
      sep = ""
    )
  colnames(hilda_data)
  return(hilda_data)
}


#' @title Remove non-missing leading numbers
#'
#' @description In HILDA all factor levels are numbered.
#'  If the leading numbers are not needed then one can
#'  use this function to recode the factor lavels.
#'
#' @param x a vector or a column from HILDA data
#'
#' @return a vector
#' @export
remove_leading_numbers <- function(x) {
  if (is.factor(x)) {
    levels(x) <-
      gsub(
        pattern = "^\\[[0-9]+\\]\\s",
        replacement = "",
        x = levels(x)
      )
    return(x)
  }
  if (is.character(x)) {
    x_new <-
      gsub(
        pattern = "^\\[[0-9]+\\]\\s",
        replacement = "",
        x = x
      )
    return(x_new)
  }
  x
}


#' Is missing data value
#'
#' @description
#' Returns TRUE if the values inside a variable contains the missing data values
#' coding from HILDA. They usally starts with `[-{number}]` or a negative value
#' if the variable is of type numeric.
#'
#' @param x a vector
#'
#' @return a logical vector
#' @export
#'
#' @examples
#' \dontrun{
#' h <- hil_fetch(2011)
#' h[is_missing_data_value(mrcurr)]
#' }
#'
is_missing_data_value <- function(x) {
  UseMethod("is_missing_data_value", x)
}

#' @export
is_missing_data_value.factor <- function(x) {
  grepl("^\\[-", x)
}

#' @export
is_missing_data_value.character <- function(x) {
  grepl("^\\[-", x)
}

#' @export
is_missing_data_value.numeric <- function(x) {
  x < 0
}

#' @export
is_missing_data_value.integer <- function(x) {
  x < 0
}



#' Make a HILDA data dictionary.
#'
#' @return `make_dict()` returns a data.table contains three
#'  columns: var, label, and wave. But if `save_dir` is not
#'  `NULL`, the dict will be saved to that location.
#' @rdname hil_setup
#' @format `hil_dict()` returns a data table with many rows and 3 variables:
#' \describe{
#'   \item{var}{(`character()`) variable names}
#'   \item{wave}{(`list(integer())`) waves that the variable was recorded}
#'   \item{label}{(`character()`) short description of the variable}
#' }
#' @export
make_dict <- function(read_dir, save_dir = NULL) {
  checkmate::assert_directory_exists(read_dir, access = "r")
  if (!is.null(save_dir)) {
    checkmate::assert_directory_exists(save_dir, access = "rw")
  }

  hilda_filedirs <- list.files(
    path = read_dir,
    pattern = "Combined_.*.dta",
    full.names = T
  )

  hilda_dict <- lapply(
    hilda_filedirs,
    function(x) {
      haven::read_stata(x, n_max = 0) %>%
        {
          data.table(
            var = names(map(., ~ attr(., which = "label"))),
            label = unlist(map(., ~ attr(., which = "label")))
          )
        }
    }
  ) %>%
    rbindlist() %>%
    unique(by = "var") %>%
    .[!grepl("^x", var), `:=`(
      wave = substr(var, 1, 1),
      var = substr(var, 2, nchar(var))
    )] %>%
    .[, wave := which(letters == wave), by = seq_len(nrow(.))] %>%
    .[, wave := as.integer(wave)] %>%
    .[, .(wave = list(wave), label = head(label, 1)), by = var]

  if (!is.null(save_dir)) {
    hilda_dict_pathname <- fs::path(save_dir, "hil_dict.rds")
    cli::cli_alert_info("Saving HILDA data dictionary at: {hilda_dict_pathname}")
    saveRDS(hilda_dict, hilda_dict_pathname)
  }

  hilda_dict
}

#' @rdname hil_setup
#' @export
#' @examples 
#' # HILDA data dictionary
#' hil_dict()
hil_dict <- function() {
  hilda_dict_path <- fs::path(get_hilda_fst_path(), "hil_dict.rds")
  checkmate::assert_file_exists(hilda_dict_path)
  readRDS(hilda_dict_path)
}

#' Get a `HILDA_FST` environment variable
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
