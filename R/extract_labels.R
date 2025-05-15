#' Extract raw data meta data
#'
#' This function extracts all variable and value labels (i.e., metadata) from an
#' SPSS file. It also identifies the variables for which no metadata is available.
#'
#' @details
#' The function performs several operations:
#' \itemize{
#'   \item Extracts variable labels for all variables in the dataset
#'   \item Identifies variables that lack variable labels
#'   \item Extracts value labels for categorical variables
#'   \item Validates that no character variables have value labels (throws an error if found)
#'   \item Identifies variables that lack value labels
#' }
#'
#' The function will throw an error if it encounters any character variables with
#' value labels, as these are not supported. The error message will list the
#' problematic variables that need to be checked.
#'
#' @param loaded_data A tibble created by reading in an SPSS .sav file using the
#'   haven package. The data must contain SPSS metadata (variable and value labels).
#' @param tibble_out Logical indicating whether to return the output as a list
#'   of tibbles (default is TRUE). If FALSE, the output will be returned as
#'   data.tables.
#'
#' @return A list containing four elements:
#'   \itemize{
#'     \item var_labels: A tibble/data.table with variable names and their labels
#'       containing columns 'var_name' and 'var_label'
#'     \item val_labels: A tibble/data.table with value labels for categorical variables
#'       containing columns 'var_name', 'val_label', and 'val_value'
#'     \item no_var_labels: A tibble/data.table with names of variables that have no
#'       variable labels
#'     \item no_val_labels: A tibble/data.table with names of variables that have no
#'       value labels
#'   }
#'
#' @export
#'
#' @examples
#' data(test_sav)
#' test_sav <- test_sav |>
#'   dplyr::select(-lab_var3)
#'
#' # extract variable and value labels
#' labels_list <- extract_labels(test_sav)
#'
extract_labels <- function(loaded_data,
                            tibble_out = TRUE){

  # capture names of variables loaded
  loaded_mask <- loaded_data |>
    colnames()

  # create variable labels data.table
  var_labels <- loaded_data |>
    labelled::get_variable_labels(unlist = TRUE) |>
    data.table::as.data.table(keep.rownames = TRUE) |>
    data.table::setnames(c('var_name', 'var_label')) |>
    _[var_label != ''] |>
    data.table::setkey('var_name')

  # create variable labels check to report variables with no variable labels
  no_var_labels <- loaded_mask |>
    setdiff(var_labels[['var_name']]) |>
    data.table::as.data.table() |>
    data.table::setnames('var_name') |>
    data.table::setkey('var_name')

  # create value labels data.table
  val_labels <- loaded_data |>
    labelled::get_value_labels()

  # check for any values with labels which aren't numeric, this should be flagged
  # as an error
  val_labels_check <- val_labels |>
    lapply(\(x) methods::is(x, 'character')) |>
    purrr::keep(\(x) isTRUE(x)) |>
    names()

  assertthat::assert_that(
    length(val_labels_check) == 0,
    msg = paste0("No value labels should be included for character variables.
The following variables should be checked: ",
                 paste(val_labels_check, collapse = ", "))
  )

  # if no errors proceed with value labels extraction
  val_labels <- val_labels |>
    lapply(data.table::as.data.table,
           keep.rownames = TRUE) |>
    data.table::rbindlist(idcol = 'var_name') |>
    data.table::setnames(c('var_name', 'val_label', 'val_value')) |>
    data.table::setkeyv(c('var_name', 'val_value'))

  # create value labels check to report variables with no value labels
  no_val_labels <- loaded_mask |>
    setdiff(val_labels$var_name |> unique()) |>
    data.table::as.data.table() |>
    data.table::setnames('var_name') |>
    data.table::setkey('var_name')

  # create list of variable and label data.tables
  labels_list <- list(var_labels = var_labels,
                        val_labels = val_labels,
                        no_var_labels = no_var_labels,
                        no_val_labels = no_val_labels)

  if(isFALSE(tibble_out)) return(labels_list)

  # convert data.tables to tibbles
  labels_list |>
    lapply(tibble::as_tibble)

}
