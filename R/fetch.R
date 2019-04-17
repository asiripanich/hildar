#' Fetch hilda data conditional on the args
#'
#' @param waves
#'  wave number, multiple waves can be put into a vector
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
#' @param responding_person_only
#'  takes a logical value to indicate whether the data should be filtered with
#'  only responding person records only or not.
#'
#'
#' @return a data.table object
#' @importFrom assertthat assert_that
#' @importFrom data.table rbindlist as.data.table setcolorder setnames
#' @importFrom fst read_fst
#' @export
hilda_fetch <-
  function(years,
    vars = NULL,
    new_varnames = NULL,
    add_population_weight = TRUE,
    add_basic_vars = TRUE,
    add_geography = FALSE,
    responding_person_only = FALSE
    ) {
    assertthat::assert_that(all(is.numeric(years)))
    # assertthat::assert_that(!is.null(vars),
    #   msg = "vars cannot be NULL. If you wish to get all columns use \"all\"")
    if (!is.null(vars)) {
      assertthat::assert_that(all(is.character(vars)))
      inp_vars <- vars # cache to match with new_varnames
    }

    if (add_population_weight) {
      pop_weight_vars <-
        c(HILDA$household_population_weight,HILDA$responding_person_population_weight)
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
    }  else {
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
    dat <- lapply(
      X = waves,
      FUN = function(wave) {
        tryCatch({
          dt <- fst::read_fst(
            path = paste0(HILDA$data_path, "/Combined_", wave, "160u.fst"),
            columns = vars,
            as.data.table = T
          )
          # add wave number
          dt[, wave := which(letters == wave)]
          setcolorder(dt, c(HILDA$xwaveid, HILDA$household_id, "wave"))
          dt
        }, error = function(e) {
          NULL
        })

      }
    )
    dat <- rbindlist(dat, fill = TRUE)

    # rename the selected columns in vars
    if (!is.null(new_varnames)) {
      assert_that(length(new_varnames) == length(inp_vars))
      setnames(dat, old = inp_vars, new = new_varnames)
    }

    dat
  }
