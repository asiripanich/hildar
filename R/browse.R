#' Browse HILDA data dictionary
#'
#' @param varname variable name
#' @param wave wave number
#'
#' @export
#'
#' @return These functions are called for their side-effect which is to
#'  launch a relavant page on a web browser.
hil_browse <- function() {
  browseURL("https://www.online.fbe.unimelb.edu.au/HILDAodd/Default.aspx")
}

#' @export
#' @rdname hil_browse
hil_crosswave_info <- function(varname) {
  checkmate::assert_string(varname)
  browseURL(
    sprintf(
      "https://www.online.fbe.unimelb.edu.au/HILDAodd/KWCrossWaveCategoryDetails.aspx?varnt=%s",
      varname
    )
  )
}

#' @export
#' @rdname hil_browse
hil_var_details <- function(varname, wave = 1) {
  checkmate::assert_string(varname)
  checkmate::assert_number(wave)
  browseURL(
    sprintf(
      "https://www.online.fbe.unimelb.edu.au/HILDAodd/VariableDetails.aspx?varn=%s&varw=%s",
      varname,
      wave
    )
  )
}
