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
  # unique_id should be logical
  expect_error(run_data_checks(test_dat, unique_id = "yes"))
  expect_no_error(run_data_checks(test_dat, unique_id = TRUE, quiet = TRUE))
  # weight should be logical or character
  expect_error(run_data_checks(test_dat, weight = 1, quiet = TRUE))
  expect_no_error(run_data_checks(test_dat, weight = TRUE, quiet = TRUE))
  expect_no_error(run_data_checks(test_dat, weight = "weight", quiet = TRUE))
  # quiet should be logical
  expect_error(run_data_checks(test_dat, quiet = "yes"))
  expect_no_error(run_data_checks(test_dat, unique_id = TRUE, quiet = TRUE))
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
  # should say if check is not run
  expect_equal(
    run_data_checks(test_dat, unique_id = FALSE, quiet = TRUE)$unique_id,
    "Check not run"
  )
})

# weight tests ----
test_that("weight var found in test_dat", {
  expect_equal(
    run_data_checks(test_dat, weight = TRUE, quiet = TRUE)$weight_var,
    "weight"
  )
  expect_equal(
    run_data_checks(test_dat, weight = "weight", quiet = TRUE)$weight_var,
    "weight"
  )
})

test_that("correct weight_summary returned for test_dat", {
  expect_equal(
    run_data_checks(test_dat, weight = "weight", quiet = TRUE)$weight_summary,
    tibble::tibble(
      variable = "weight",
      mean = 1,
      median = 1,
      var = 0,
      sd = 0,
      min = 1,
      max = 1,
      missing = as.integer(0),
      missing_percent = 0
    )
  )
})

test_that("no weight summary if weight not found", {
  expect_null(
    run_data_checks(test_dat, weight = "bogus_weight", quiet = T)$weight_summary
    )
})

test_that("multiple weight vars are summarised", {
  expect_equal(
    run_data_checks(
      dplyr::mutate(test_dat, weight2 = ifelse(respid > 50, NA_real_, weight)),
      quiet = T
    )$weight_summary |>
      nrow(),
    2
  )
})
