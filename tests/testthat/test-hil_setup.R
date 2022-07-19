test_that("hil_setup", {
  testthat::skip("requires a manual execution")
  hilda_read_path <- "/Users/amarin/data/hildar_read_test"
  hilda_save_path <- "/Users/amarin/data/hildar_save_test"
  hil_setup(hilda_read_path, hilda_save_path)

  library(future)
  plan(multisession, workers = 2)
  progressr::with_progress({
    hil_setup(hilda_read_path, hilda_save_path)
  })
})
