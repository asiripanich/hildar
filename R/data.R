#' @title HILDA dictionary in a data.table format.
#'
#' @description
#'
#' A data.table that contains a dictionary of the loaded HILDA datasets.
#'
#' @docType data
#'
#' @usage data(hil_dict)
#' @format A data table with many rows and 3 variables:
#' \describe{
#'   \item{var}{(`character()`) variable names}
#'   \item{wave}{(`list(integer())`) waves that the variable was recorded}
#'   \item{label}{(`character()`) short description of the variable}
#' }
#'
#' @examples
#' hil_dict
"hil_dict"
