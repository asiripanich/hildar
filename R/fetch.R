#' Fetch HILDA data
#'
#' @param years
#'  years (e.g. wave 1 = 2001), multiple waves can be put into a vector.
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
hil_fetch <-
  function(years,
           vars = NULL,
           new_varnames = NULL,
           add_population_weight = TRUE,
           add_basic_vars = TRUE,
           add_geography = FALSE,
           hilda_fst_dir = ifelse(!is.null(getOption("HILDA_FST")),
             getOption("HILDA_FST"),
             Sys.getenv("HILDA_FST")
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
    checkmate::assert_integerish(years, any.missing = FALSE)
    checkmate::assert_subset(years, choices = 2001:2016)
    #   msg = "vars cannot be NULL. If you wish to get all columns use \"all\"")
    if (!is.null(vars)) {
      checkmate::assert_character(vars, any.missing = FALSE)
      inp_vars <- vars # cache to match with new_varnames
    }

    if (add_population_weight) {
      pop_weight_vars <-
        c(
          HILDA$household_population_weight,
          HILDA$responding_person_population_weight
        )
    } else {
      pop_weight_vars <- NULL
    }

    if (add_basic_vars == TRUE) {
      basic_vars <- c("hgage", "hgsex", "mrcurr", "hhrih")
    } else {
      basic_vars <- NULL
    }

    if (add_geography == TRUE) {
      geography_vars <- c("hhsgcc")
    } else {
      geography_vars <- NULL
    }

    if (any(vars %in% "all")) {
      vars <- NULL
    } else {
      vars <-
        unique(
          c(
            HILDA$xwaveid,
            HILDA$household_id,
            basic_vars,
            vars,
            geography_vars,
            pop_weight_vars
          )
        )
    }

    waves <- letters[years - 2000]
    dat_ls <- lapply(
      X = waves,
      FUN = function(wave) {
        tryCatch(
          {
            path_to_fst <-
              fs::path(hilda_fst_dir, paste0("Combined_", wave, "160u.fst"))
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
            setcolorder(dt, c(HILDA$xwaveid, HILDA$household_id, "wave"))
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
  lifecycle::deprecate_soft("0.4.0", "mlfit::fetch()", "mlfit::hil_fetch()")
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
.fst_colnames_exist <- function(path, colnames) {
  first_row_dt <- fst::read.fst(path, to = 1, as.data.table = T)

  colnames_exist <- colnames %in% names(first_row_dt)

  colnames[colnames_exist]
}
