context("fetch")

test_that("get one year data", {
  data <- hildar::fetch(years = 2011)
  expect_true(data[, unique(wave)] == 11)
  expect_true(nrow(data) != 0)
  expect_true(ncol(data) != 0)
})
