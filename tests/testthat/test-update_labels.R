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

test_that("update_val_labels input validation works", {
  # dat must be a data frame
  expect_error(update_val_labels(c(1, 2, 3), new_dat_val_labels))
  # new_var_labels must be a data frame
  expect_error(update_val_labels(test_dat, c("new lab1", "new lab2")))
  # new_val_labels must have 3 columns
  expect_error(
    update_val_labels(
      test_dat,
      tibble::tibble(var = c("q1", "q1.1"),
                     label = c("new lab1", "new lab2")))
  )
  expect_error(
    update_val_labels(
      test_dat,
      tibble::tibble(var = c("q1", "q1.1"),
                     value = c(1:2),
                     label = c("new lab1", "new lab2"),
                     label2 = c("new lab3", "new lab4"))
      )
  )
})

test_that("val labels are correctly updated", {
  expect_equal(
    update_val_labels(test_dat, new_dat_val_labels) |>
      get_valLabels(),
    tibble::tibble(
      variable = c(rep("q1", 4), rep("q1.1", 4)),
      value = rep(1:4, 2),
      `value label` = c(paste("q1 label", 1:4), LETTERS[1:4])
    )
  )
})
