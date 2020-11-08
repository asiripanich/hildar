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
      sep = "")
  colnames(hilda_data)
  return(hilda_data)
}


#' @title Remove non-missing leading numbers
#'
#' @description In HILDA all factor levels are numbered. If the leading numbers are not needed
#' then one can use this function to recode the factor lavels.
#'
#' @param x a vector or a column from HILDA data
#'
#' @return a vector
#' @export
remove_leading_numbers <- function(x) {
  if (is.factor(x)) {
    levels(x) <-
      gsub(pattern = "^\\[[0-9]+\\]\\s",
           replacement = "",
           x = levels(x))
    return(x)
  }
  if (is.character(x)) {
    x_new <-
      gsub(pattern = "^\\[[0-9]+\\]\\s",
           replacement = "",
           x = x)
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
#'
#' \dontrun{
#' h <- fetch(2011)
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
