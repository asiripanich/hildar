#' Return the user default HILDA variables.
#'
#' @description
#' This function returns the user default HILDA variables ("HILDAR_USER_DEFAULT_VARS")
#' that can be found in `.Rprofile` and `.Renviron`. If 'HILDAR_USER_DEFAULT_VARS' in 
#' both files are set, the function will give higher priority to the variables set in .Rprofile.
#' 
#' To edit both files, you can use [usethis::edit_r_profile()] and [usethis::edit_r_environ()].
#'
#' By default, [hil_fetch()] will select the variables returned by [hil_user_default_vars()]
#' in its output.
#' 
#' @return User default variable names as a character vector.
#'
#' @export
#' @examples 
#' hil_user_default_vars()
hil_user_default_vars <- function() {
  vars_in_dot_rprofile <- getOption("HILDAR_USER_DEFAULT_VARS")
  vars_in_dot_renviron <- unlist(strsplit(Sys.getenv("HILDAR_USER_DEFAULT_VARS"), split = ","))

  cli::cli_alert_info("`HILDAR_USER_DEFAULT_VARS` in Rprofile: {.var {vars_in_dot_rprofile}}")
  cli::cli_alert_info("`HILDAR_USER_DEFAULT_VARS` in Renviron: {.var {vars_in_dot_renviron}}")

  if (!is.null(vars_in_dot_rprofile)) {
    return(vars_in_dot_rprofile)
  }
  if (length(vars_in_dot_renviron) != 0) {
    return(vars_in_dot_renviron)
  }
  NULL
}
