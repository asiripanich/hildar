#' Return the user default HILDA variables.
#'
#' @description
#' This function returns the user default HILDA variables ("HILDAR_USER_DEFAULT_VARS")
#' that can be found in `.Rprofile` and `.Renviron`. If 'HILDAR_USER_DEFAULT_VARS' in
#' both files are set, the function will give higher priority to the variables set in .Rprofile.
#'
#' By default, [hil_fetch()] will select the variables returned by [hil_user_default_vars()]
#' in its output.
#'
#' @note
#'
#' To edit both files, you can use [usethis::edit_r_profile()] and [usethis::edit_r_environ()].
#'
#' For `.Renviron`, please make sure `HILDAR_USER_DEFAULT_VARS` has the following format:
#'
#' ```
#' HILDAR_USER_DEFAULT_VARS="hhid, losat"
#' ```
#'
#' For `.Rprofile`, please make sure `HILDAR_USER_DEFAULT_VARS` has the following format:
#'
#' ```
#' options(HILDAR_USER_DEFAULT_VARS = c("hhid", "losat"))
#' ```
#'
#' The main advantage of setting the variables in your `.Renviron` file is
#' that all your new R sessions that don't have a project-specific `.Rprofile`
#' file will use the `HILDAR_USER_DEFAULT_VARS` from your `.Renviron` file.
#'
#' However, if you have a project that requires a specific set of variables, it is
#' recommended that you use the `.Rprofile` option.
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
