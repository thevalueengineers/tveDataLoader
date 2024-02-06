test_that("input validation works", {
  expect_error(run_data_checks(1:3))
  expect_error(run_data_checks(letters[1:3]))
  expect_error(run_data_checks(list(letters[1:3])))
})
