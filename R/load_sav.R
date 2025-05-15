#' Read in SPSS .sav files and convert variable names to lower case
#'
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' Wrapper around haven::read_sav() and stringr::str_to_lower(). This function
#' has now been superseded by [load_sav()].
#'
#' @param filepath Character storing filepath, including filename, of the sav file to be read in
#'
#' @export
read_sav <- function(filepath) {
  dat <- haven::read_sav(filepath)

  ## variable names to lower
  names(dat) <- stringr::str_to_lower(names(dat))

  return(dat)
}


#' Load tidy SPSS Data
#'
#' This function loads SPSS data and creates data.tables for variable labels and value labels.
#'
#' @param data_path Path to the SPSS data file.
#' @param keyv A character vector of variable names to set as keys for the data.table.
#' @param col_omit A character vector of column names to omit from the loaded data.
#' @inheritParams extract_labels
#'
#' @details The loaded SPSS data has all labels removed via `haven::zap_labels()`.
#'
#' @return A list containing:
#' \describe{
#'  \item{var_labels}{A data.table or tibble containing variable labels.}
#'  \item{no_var_labels}{A data.table or tibble containing variables with no variable labels.}
#'  \item{val_labels}{A data.table or tibble containing value labels.}
#'  \item{no_val_labels}{A data.table or tibble containing variables with no value labels.}
#'  \item{loaded_data}{The loaded SPSS data as a data.table or tibble.}
#'  }
#'
#' @export
#'
#' @examples
#' # Define path to SPSS file to be loaded
#' data_path <- system.file("extdata", "test_sav.sav", package = "tveDataLoader")
#'
#' # Load the SPSS file using load_sav omitting non-valid columns
#' loaded_data <- load_sav(data_path, col_omit = 'lab_var3')
#'
load_sav <- function(data_path,
                     keyv = c('respid'),
                     col_omit = NULL,
                     tibble_out = TRUE){

  # load SPSS data
  loaded_data <- haven::read_sav(data_path) |>
    janitor::clean_names()

  # validation that keyv are in the data
  assertthat::assert_that(
    all(keyv %in% names(loaded_data)),
    msg = paste0("Key variables not found in data: ",
                 paste(keyv[!keyv %in% names(loaded_data)], collapse = ", "))
  )

  loaded_data <- loaded_data |>
    data.table::setDT(key = keyv)

  # omit columns if specified
  if(isFALSE(is.null(col_omit))) {

    # validation that col_omit are in the data
    assertthat::assert_that(
      all(col_omit %in% names(loaded_data)),
      msg = paste0("Columns to omit not found in data: ",
                   paste(col_omit[!col_omit %in% names(loaded_data)], collapse = ", "))
    )
    loaded_data[, (col_omit) := NULL]

  }

  out_list <- extract_labels(loaded_data,
                             tibble_out = tibble_out)

  # create list of output tables
  if(isTRUE(tibble_out)) {

    out_list$loaded_data <- loaded_data |>
      haven::zap_labels() |>
      tibble::as_tibble()

  } else {

    out_list$loaded_data <- loaded_data |>
      haven::zap_labels()

  }

  return(out_list)

}
