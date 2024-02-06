test_that("input validation works", {
  # data should be a data frame
  expect_error(run_data_checks(1:3))
  expect_error(run_data_checks(letters[1:3]))
  expect_error(run_data_checks(list(letters[1:3])))
  expect_no_error(run_data_checks(test_dat, quiet = TRUE))
  # vars should be a character vector
  expect_error(run_data_checks(test_dat, tibble(a = 1)))
  expect_error(run_data_checks(test_dat, 1:3))
  expect_error(run_data_checks(test_dat, list(letters[1:3])))
  expect_no_error(run_data_checks(test_dat, c("q1", "q1.1"), quiet = TRUE))
})

test_that("unique IDs checks", {
  # should find respid in test that
  expect_equal(run_data_checks(test_dat, quiet = TRUE)$unique_id, "respid")
  # should find no ID when respid removed
  expect_equal(run_data_checks(test_dat[-1], quiet = TRUE)$unique_id, "No ID")
  # should list multiple ids when more than 1 unique var
  expect_equal(
    run_data_checks(
      tibble::add_column(test_dat, respid2 = nrow(test_dat):1),
      quiet = TRUE
    )$unique_id,
    c("respid", "respid2")
  )
})
