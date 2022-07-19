test_that("hil_labs()", {
  skip_on_ci()
  checkmate::expect_character(hil_labs("income"),  min.len = 1)
  checkmate::expect_character(hil_labs("^HF"),  min.len = 1)
})
