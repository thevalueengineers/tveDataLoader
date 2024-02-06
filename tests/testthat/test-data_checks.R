test_that("input validation works", {
  # data should be a data frame
  expect_error(run_data_checks(1:3))
  expect_error(run_data_checks(letters[1:3]))
  expect_error(run_data_checks(list(letters[1:3])))
  expect_no_error(run_data_checks(test_dat))
  # vars should be a character vector
  expect_error(run_data_checks(test_dat, tibble(a = 1)))
  expect_error(run_data_checks(test_dat, 1:3))
  expect_error(run_data_checks(test_dat, list(letters[1:3])))
  expect_no_error(run_data_checks(test_dat, c("q1", "q1.1")))
})
