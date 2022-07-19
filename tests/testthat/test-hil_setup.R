test_that("hil_setup", {
  # testthat::skip("requires a manual execution")
  hilda_read_path <- here::here("data-raw")
  hilda_save_path <- tempdir()
  hil_setup(hilda_read_path, hilda_save_path)
  checkmate::expect_data_frame(
    hil_fetch(c(2001, 2011, 2020), hilda_fst_dir = hilda_save_path, vars = "all"),
    nrows = 3,
    min.cols = 3
  )
  checkmate::expect_data_frame(
    hil_dict(hilda_fst_dir = hilda_save_path),
    min.rows = 1,
    ncols = 3
  )
  future::plan(future::multisession, workers = 2)
  progressr::with_progress({
    hil_setup(hilda_read_path, hilda_save_path)
  })

  checkmate::expect_character(hil_labs("income"),  min.len = 1)
  checkmate::expect_character(hil_labs("^HF"),  min.len = 1)

  checkmate::expect_character(hil_labs("income"),  min.len = 1)
  checkmate::expect_character(hil_labs("^HF"),  min.len = 1)
})
