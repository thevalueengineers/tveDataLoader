test_that("update_var_labels input validation works", {
  # dat must be a data frame
  expect_error(update_var_labels(c(1, 2, 3), new_dat_var_labels))
  # new_var_labels must be a data frame
  expect_error(update_var_labels(test_dat, c("new lab1", "new lab2")))
  # new_var_labels must have 2 columns
  expect_error(
    update_var_labels(test_dat, tibble::tibble(var = c("q1", "q1.1")))
  )
  expect_error(
    update_var_labels(
      test_dat,
      tibble::tibble(var = c("q1", "q1.1"),
                     label = c("new lab1", "new lab2"),
                     label2 = c("new lab3", "new lab4")))
  )
})

test_that("var labels are correctly updated", {
  expect_equal(
    update_var_labels(test_dat, new_dat_var_labels) |>
      get_varLabels(),
    tibble::tibble(
      variable = c("q1", "q1.1"),
      label = c("q1 label", "q1.1 label")
    )
  )
})
