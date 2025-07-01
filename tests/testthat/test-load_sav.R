data_path <- system.file("extdata", "test_sav.sav", package = "tveDataLoader")

test_that("Function loads SPSS file as tibbles with valid data", {

  loaded_data <- load_sav(data_path,
                          col_omit = c('lab_var3'),
                        keyv = 'respid_test')

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
                          tibble_out = FALSE,
                          keyv = 'respid_test')

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
  testthat::expect_error(load_sav(data_path, keyv = 'respid_test'),
                         regexp = 'No value labels should be included for character variables.
The following variables should be checked: lab_var3')

  # ensure the function stops if keyv variables are not in the data
  testthat::expect_error(load_sav(data_path,
                                  keyv = 'madeupvar'),
                         regexp = 'Key variables not found in data: madeupvar')

  # ensure the function stops if col_omit variables are not in the data
  testthat::expect_error(load_sav(data_path,
                                  col_omit = 'madeupvar',
                                  keyv = 'respid_test'),
                         regexp = 'Columns to omit not found in data: madeupvar')

})


test_that("Function loads SPSS file and creates column respid if not specified in keyv", {

  loaded_data <- load_sav(data_path,
                          col_omit = c('lab_var3'),
                          keyv_name = 'respid',
                          tibble_out = FALSE)
                          
  # confirm new variable respid is created as a vector of integers: 1:nrow(loaded$data) labelled 
  # with 'respid' as label.
  testthat::expect_identical(loaded_data$respid,
    labelled::labelled(1:nrow(loaded_data$loaded_data),
                       label = 'respid')
  )

  # confirm selected variable is set as the key variable
  testthat::expect_true(data.table::key(loaded_data$loaded_data) == 'respid')

})