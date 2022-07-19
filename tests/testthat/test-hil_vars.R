test_that("hil_vars()", {
  checkmate::expect_character(hil_vars("^lo"), min.len = 1)
  checkmate::expect_names(hil_vars("^lo"), must.include = "losat")
})
