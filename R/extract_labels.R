#' Extract raw data meta data
#'
#' This function extracts all variable and value labels (i.e., metadata) from an
#' SPSS file. It also identifies the variables for which no metadata is available.
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
    labelled::get_value_labels() |>
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
