test_that("hil_setup", {
  hilda_read_dir <- system.file("extdata", package = "hildar")
  hilda_save_dir <- fs::path(tempdir(), "hildar_fst_test_setup")
  dir.create(hilda_save_dir)
  
  hil_setup(hilda_read_dir, hilda_save_dir)

  hilda_filenames <- list.files(hilda_read_dir) %>% 
    basename() %>% 
    sub('\\.dta$', '', .)

  for (hilda_filename in hilda_filenames) {
    checkmate::expect_file_exists(
      fs::path(hilda_save_dir, paste0(hilda_filename, ".fst"))
    )
  }

  checkmate::expect_file_exists(fs::path(hilda_save_dir, "hil_dict.rds"))

  future::plan(future::multisession, workers = 2)
  progressr::with_progress({
    hil_setup(hilda_read_dir, hilda_save_dir)
  })

  # remove the test setup
  unlink(hilda_save_dir, recursive = TRUE)
})
