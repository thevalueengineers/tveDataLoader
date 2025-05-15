data_path <- system.file("extdata", "test_sav.sav", package = "tveDataLoader")

test_that("Function loads SPSS file as tibbles with valid data", {

  loaded_data <- load_sav(data_path,
                          col_omit = c('lab_var3'))

  # confirm dimensions of loaded data are as expected
  testthat::expect_equal(dim(loaded_data$loaded_data),
               dim(test_sav |> dplyr::select(-lab_var3)))

  # confirm the expected named list is returned
  testthat::expect_named(loaded_data,
                         c('var_labels', 'val_labels',  'no_var_labels',
                           'no_val_labels', 'loaded_data'))

  # confirm class of all elements in the list are tibbles
  testthat::expect_true(

    loaded_data |>
      sapply(methods::is,'tbl_df') |>
      all()

  )

})


test_that("Function loads SPSS file as data.tables with valid data", {

  loaded_data <- load_sav(data_path,
                          col_omit = c('lab_var3'),
                          tibble_out = FALSE)

  # confirm the expected named list is returned
  testthat::expect_named(loaded_data,
                         c('var_labels', 'val_labels',  'no_var_labels',
                           'no_val_labels', 'loaded_data'))

  # confirm class of all elements in the list are tibbles
  testthat::expect_true(

    loaded_data |>
      sapply(methods::is,'data.table') |>
      all()

  )

})


test_that("Function stops if validation criteria is not met", {

  # ensure the function stops if some variables have value labels and are character
  testthat::expect_error(load_sav(data_path),
                         regexp = 'No value labels should be included for character variables.
The following variables should be checked: lab_var3')

  # ensure the function stops if keyv variables are not in the data
  testthat::expect_error(load_sav(data_path,
                                  keyv = 'madeupvar'),
                         regexp = 'Key variables not found in data: madeupvar')

  # ensure the function stops if col_omit variables are not in the data
  testthat::expect_error(load_sav(data_path,
                                  col_omit = 'madeupvar'),
                         regexp = 'Columns to omit not found in data: madeupvar')

})
