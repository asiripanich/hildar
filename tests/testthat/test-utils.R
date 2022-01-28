test_that("hil_vars", {
  skip_on_cran()
  skip_on_ci()
  checkmate::expect_character(hil_vars("^x"))
})
