#' Remove the leading alphabets of all the columns
#' except those start with 'x'
#' @param hilda_df HILDA data
#'
#' @return data.table
#' @export
standardise_hilda_colnames <- function(hilda_data) {
  first_chars <- substr(colnames(hilda_data), 1, 1)
  notfirst_chars <- substr(colnames(hilda_data), 2, 1000)
  colnames(hilda_data) <-
    paste(ifelse(first_chars == first_chars[2], "", first_chars),
      notfirst_chars,
      sep = "")
  colnames(hilda_data)
  return(hilda_data)
}


#' @title Remove non-missing leading numbers
#'
#' @description In HILDA all factor levels are numbered. If the leading numbers are not needed
#' then one can use this function to recode the factor lavels.
#'
#' @param var a vector of hilda var
#'
#' @return a vector
#' @export
remove_leading_numbers <- function(var) {
  if (is.factor(var)) {
    levels(var) <-
      gsub(pattern = "^\\[[0-9]+\\]\\s",
        replacement = "",
        x = levels(var))
    return(var)
  } else {
    stop("var is not factor")
  }
}


#' Make a dictionary for a STATA dta file.
#'
#' @param stata_df a data.frame read using haven::read_stata
#'
#' @return a data.table contains two columns: var and label.
#'
#' @import data.table
#'
#' @export
make_dict <- function(stata_df) {
  data.table(
    var = names(map(stata_df, ~ attr(., which = "label"))),
    label = unlist(map(stata_df, ~ attr(., which = "label")))
  )
}