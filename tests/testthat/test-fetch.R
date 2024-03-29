test_that("get one year data", {
  skip_on_ci()
  skip_on_cran()

  data <- hildar::hil_fetch(years = 2011)
  expect_true(data[, unique(wave)] == 11)
  expect_true(nrow(data) != 0)
  expect_true(ncol(data) != 0)
})


test_that("get missing data in one wave", {
  skip_on_ci()
  skip_on_cran()

  selected_years <- 2011:2012
  # Note:
  # skdrvl: Currently holds a motor vehicle license
  # only exists in wave 12 and 16
  data <- hildar::hil_fetch(years = selected_years, vars = "skdrvl")
  expect_true(data[, data.table::uniqueN(wave)] == length(selected_years))
  expect_true(nrow(data) != 0)
  expect_true(ncol(data) != 0)
})
