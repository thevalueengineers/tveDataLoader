# create expected outcomes for testing as data.tables
expected_list_dt <- list(
  var_labels = data.table::data.table(
    var_name = c('lab_var1', 'lab_var2', 'respid'),
    var_label = c('v1 label', 'v2 label', 'respid')
  ) |>
    data.table::setkey('var_name'),
  val_labels = data.table::data.table(
    var_name = c(rep('lab_var1', 4),
                 rep('lab_var2', 2)),
    val_label = c(LETTERS[1:4], letters[1:2]),
    val_value = c(1:4, 1:2)
  ) |>
    data.table::setkeyv(c('var_name', 'val_value')),
  no_var_labels = data.table::data.table(
    var_name = c('char_var1', 'num_var1')
  ) |>
    data.table::setkey('var_name'),
  no_val_labels = data.table::data.table(
    var_name = c('char_var1', 'num_var1', 'respid')
  ) |>
    data.table::setkey('var_name')
)

# create expected outcomes for testing as tibbles
expected_list_tibble <- expected_list_dt |>
  lapply(tibble::as_tibble)

test_that("Function works with all defaults as expected", {

  new_list <- test_sav |>
    dplyr::select(-lab_var3) |>
    extract_labels()

  expect_equal(new_list, expected_list_tibble)

})

test_that("Function works returning data.tables", {

  new_list <- test_sav |>
    dplyr::select(-lab_var3) |>
    extract_labels(tibble_out = FALSE)

  expect_equal(new_list, expected_list_dt)

})

test_that("Function stops if character values with labels present", {

  expect_error(extract_labels(test_sav),
               regexp = 'No value labels should be included for character variables.
The following variables should be checked: lab_var3')

})

