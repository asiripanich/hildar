test_that("Test hil_dict()", {
checkmate::expect_data_frame(
    hil_dict(),
    min.rows = 1,
    ncols = 3
  )
})