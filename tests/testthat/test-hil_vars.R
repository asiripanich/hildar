test_that("hil_vars()", {
  skip_on_ci()
  checkmate::expect_character(hil_vars("^lo"), min.len = 1)
  checkmate::expect_names(hil_vars("^lo"), must.include = "losat")
})
