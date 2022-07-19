#' Fetch HILDA data
#'
#' Fetch HILDA data from the HILDA fst files created by [hil_setup()].
#' To set default variables for [hil_fetch()] to fetch see [hil_user_default_vars()].
#'
#' @param years
#'  This argument allow you to specify the years of HILDA
#'  that you like to load instead of using alphabets.
#'  The first wave of HILDA was in 2001 and known as wave 'a',
#'  and the following year was wave 'b'. To load multiple waves
#'  you can be put use a numeric vector (e.g.,`2001:2009` would load all waves
#'  between 2001 and 2009).
#' @param vars
#'  a vector containing all desired variable names to be loaded. vars can
#'  be set to "all" to fetch all columns. This may take a long time to load
#' @param new_varnames
#'  a vector contains character names with its length equals length of `vars` to
#'  be replaced by `vars` orgininal names.
#' @param add_population_weight
#'  take a logical value whether to add cross-sectional responding person weight
#'   column and enumerated weight
#'  column to the data
#' @param add_basic_vars
#'  take a logical value whether to add hgage (age), hgsex (sex),
#'  mrcurr (marital status) and
#'  hhrih (relationship in household) to the data
#' @param add_geography
#'  take a logical value whether to add hhsgcc (Greater statistical region)
#'  to the data
#' @param hilda_fst_dir a directory where HILDA files in fst format are stored
#'  by `hil_setup()`. If not given the function will check uses for 'HILDA_FST'
#'  in your `.Rprofile` file first, then in `.Renviron` file.
#'
#' @return a data.table object
#' @importFrom data.table rbindlist as.data.table setcolorder setnames
#' @importFrom fst read_fst
#' @export
#'
#' @examples
#' summary(hil_fetch(2011))
#'
#' summary(hil_fetch(2011:2012, vars = "losat"))
#'
#' # Query all variables that start with 'hs' (Housing)
#' summary(hil_fetch(2011, vars = hil_vars("^hs")))
#'
#' # Query all variables with the word 'coronavirus' in their variable description.
#' summary(hil_fetch(2020, vars = hil_labs("coronavirus")))
hil_fetch <-
  function(years = NULL,
           vars = NULL,
           new_varnames = NULL,
           add_population_weight = TRUE,
           add_basic_vars = TRUE,
           add_geography = FALSE,
           hilda_fst_dir = ifelse(!is.null(getOption("HILDA_FST")),
             getOption("HILDA_FST"),
             get_hilda_fst_path()
           )) {
    if (!checkmate::test_directory_exists(hilda_fst_dir, access = "r")) {
      stop(
        "There is no `HILDA_FST` in your global options or in your ",
        "R environment variables. Please use `hil_setup()` to setup ",
        "before using this function. Alternatively, you can provide ",
        "a directory that has HILDA files in the `fst` format in ",
        "the `hilda_fst_dir` argument."
      )
    }
    available_waves <- list.files(
      path = hilda_fst_dir,
      pattern = "Combined_[a-z]\\d{3}(u|c).fst",
      full.names = TRUE
    ) %>%
      basename() %>%
      gsub("Combined_", "", .) %>%
      gsub("\\d.*", "", .) %>%
      tolower()
    available_years <- 2000 + seq_along(letters)[letters %in% available_waves]
    checkmate::assert_integerish(years, any.missing = FALSE)
    checkmate::assert_subset(years, choices = available_years)
    #   msg = "vars cannot be NULL. If you wish to get all columns use \"all\"")
    if (!is.null(vars)) {
      checkmate::assert_character(vars, any.missing = FALSE)
      inp_vars <- vars # cache to match with new_varnames
    }

    if (length(vars) == 1 && vars == "all") {
      vars <- NULL
    } else {
      if (add_population_weight) {
        vars <-
          c(
            vars,
            HILDA$household_population_weight,
            HILDA$responding_person_population_weight
          )
      }

      if (add_basic_vars == TRUE) {
        vars <- c(vars, "hgage", "hgsex", "mrcurr", "hhrih")
      }

      if (add_geography == TRUE) {
        vars <- c(vars, "hhsgcc")
      }

      vars <-
        unique(
          c(
            HILDA$xwaveid,
            vars,
            hil_user_default_vars()
          )
        )
    }

    waves <- letters[years - 2000]
    dat_ls <- lapply(
      X = waves,
      FUN = function(wave) {
        tryCatch(
          {
            path_to_fst <- list.files(
              path = hilda_fst_dir,
              pattern = paste0("Combined_", wave, "\\d{3}(u|c).fst"),
              full.names = TRUE
            )
            if (length(path_to_fst) != 1) {
              cli::cli_alert_danger(
                "There are more than one HILDA file that matches wave {.field {wave}}:"
              )
              cli::cli_ol(path_to_fst)
              stop("Please check your HILDA fst directory for duplicated files or file an issue.")
            }
            dt <- fst::read_fst(
              path = path_to_fst,
              columns = .fst_colnames_exist(path_to_fst, vars),
              as.data.table = T
            )
            # convert all factors to strings
            fct_cols <- names(dt)[sapply(dt, is.factor)]
            for (fct_col in fct_cols) {
              data.table::set(
                x = dt,
                j = fct_col,
                value = as.character(dt[[fct_col]])
              )
            }
            # add wave number
            dt[, wave := which(letters == wave)]
            main_col_orders <- c(
              HILDA$xwaveid,
              HILDA$household_id_restricted_release,
              HILDA$household_id_general_release,
              "wave"
            )
            setcolorder(
              dt,
              main_col_orders[main_col_orders %in% colnames(dt)]
            )
            dt
          },
          error = function(e) {
            NULL
          }
        )
      }
    )

    dat <- rbindlist(dat_ls, fill = TRUE)

    # rename the selected columns in vars
    if (!is.null(new_varnames)) {
      stopifnot(length(new_varnames) == length(inp_vars))
      setnames(dat, old = inp_vars, new = new_varnames)
    }

    dat
  }

#' Fetch HILDA data
#'
#' Soft-deprecated, new code should use [hil_fetch()].
#'
#' @return See [hil_fetch()].
#' @importFrom lifecycle deprecate_soft
#' @export
#' @keywords internal
fetch <- function(years,
                  vars = NULL,
                  new_varnames = NULL,
                  add_population_weight = TRUE,
                  add_basic_vars = TRUE,
                  add_geography = FALSE,
                  .dir = getOption("hildar.vault")) {
  lifecycle::deprecate_soft("0.1.0", "hildar::fetch()", "hildar::hil_fetch()")
  hil_fetch(
    years,
    vars,
    new_varnames,
    add_population_weight,
    add_basic_vars,
    add_geography,
    .dir
  )
}


#' Returns column names that exists in a .fst file
#'
#' @param path path to a .fst file
#' @param colnames a character vector to check
#'
#' @noRd
#'
#' @return column names in colnames that exists in the .fst file
.fst_colnames_exist <- function(path, vars) {
  column_names <- .fst_colnames(path)
  vars_exist <- vars %in% column_names
  missing_vars <- vars[!vars_exist]
  if (length(missing_vars) > 0) {
    cli::cli_alert_warning("These variables: {.var {missing_vars}} don't exist in {.path {path}}.")
  }
  vars[vars_exist]
}

.fst_colnames <- function(path) {
  colnames(fst::read.fst(path, to = 1, as.data.table = T))
}
