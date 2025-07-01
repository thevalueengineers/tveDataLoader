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
#' The function can automatically create or use existing key variables for data.table indexing.
#'
#' @param data_path Path to the SPSS data file.
#' @param keyv A character vector of variable names that exist in the data to set as keys 
#'   for the data.table. If NULL (default), the function will use or create a key variable 
#'   based on the `keyv_name` parameter.
#' @param keyv_name A character string specifying the name of the key variable to use when 
#'   `keyv` is NULL. If this variable exists in the data, it will be used as the key. 
#'   If it does not exist, a new sequential variable with this name will be created and 
#'   used as the key. Default is "respid".
#' @param col_omit A character vector of column names to omit from the loaded data.
#' @inheritParams extract_labels
#'
#' @details 
#' The function performs the following operations:
#' \itemize{
#'   \item{Loads SPSS data using \code{haven::read_sav()} and cleans variable names}
#'   \item{Sets up data.table keys based on the \code{keyv} and \code{keyv_name} parameters}
#'   \item{Removes specified columns if \code{col_omit} is provided}
#'   \item{Extracts variable and value labels using \code{extract_labels()}}
#'   \item{Removes all labels from the final data using \code{haven::zap_labels()}}
#' }
#' 
#' Key variable behavior:
#' \itemize{
#'   \item{If \code{keyv} is provided: Uses the specified existing variables as keys}
#'   \item{If \code{keyv} is NULL and \code{keyv_name} exists in data: Uses that variable as key}
#'   \item{If \code{keyv} is NULL and \code{keyv_name} does not exist: Creates a new sequential variable with the specified name}
#' }
#'
#' @return A list containing:
#' \describe{
#'  \item{var_labels}{A data.table or tibble containing variable labels.}
#'  \item{no_var_labels}{A data.table or tibble containing variables with no variable labels.}
#'  \item{val_labels}{A data.table or tibble containing value labels.}
#'  \item{no_val_labels}{A data.table or tibble containing variables with no value labels.}
#'  \item{loaded_data}{The loaded SPSS data as a data.table or tibble with labels removed.}
#'  }
#'
#' @export
#'
#' @examples
#' # Define path to SPSS file to be loaded
#' data_path <- system.file("extdata", "test_sav.sav", package = "tveDataLoader")
#'
#' # Load the SPSS file using default settings (creates "respid" key) & omits specific columns
#' loaded_data1 <- load_sav(data_path, col_omit = "lab_var3")
#'
#' # Load with custom key name
#' loaded_data2 <- load_sav(data_path, keyv_name = "id", col_omit = "lab_var3")
#'
#' # Load using existing variables as keys
#' loaded_data3 <- load_sav(data_path, keyv = c("lab_var1", "lab_var2"), col_omit = "lab_var3")
#'
#' # Load as data.table instead of tibble
#' loaded_data4 <- load_sav(data_path, col_omit = "lab_var3", tibble_out = FALSE)
#'
load_sav <- function(data_path,
                     keyv = NULL,
                     keyv_name = "respid",
                     col_omit = NULL,
                     tibble_out = TRUE){

  # load SPSS data
  loaded_data <- haven::read_sav(data_path) |>
    janitor::clean_names()

  # validation that keyv are in the data (only if keyv is not NULL)
  if(!is.null(keyv)) {
    assertthat::assert_that(
      all(keyv %in% names(loaded_data)),
      msg = paste0("Key variables not found in data: ",
                   paste(keyv[!keyv %in% names(loaded_data)], collapse = ", "))
    )
  }

  # determine if key needs to be created or simply set
  if(isTRUE(is.null(keyv))){

    # if keyv is not provided and keyv_name is not in the data,
    # create a new sequential variable to be used as key
    if(isFALSE(keyv_name %in% names(loaded_data))) {

      loaded_data |>
        data.table::setDT()

      data.table::set(loaded_data,
        j = keyv_name,
        value = labelled::labelled(seq_len(nrow(loaded_data)),
        label = keyv_name)
      )
      
      loaded_data |>
        data.table::setkeyv(cols = keyv_name)

    # if keyv_name is in the data, set it as key  
    } else {

      loaded_data |>
        data.table::setDT(key = keyv_name)
    
    }    
  
  # if keyv is provided, set it as key
  } else {

    loaded_data |>
      data.table::setDT(key = keyv)

  }


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
