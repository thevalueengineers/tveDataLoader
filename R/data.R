#' Test Dataset
#'
#' A sample dataset containing survey responses with labelled variables.
#'
#' @format A tibble with 100 rows and 4 columns:
#' \describe{
#'   \item{respid}{Respondent ID (1-100)}
#'   \item{q1}{A labelled variable with values 1-4, labelled as A through D}
#'   \item{q1.1}{A labelled variable with values 1-4, labelled as A through D}
#'   \item{weight}{Survey weight, all set to 1}
#' }
#'
#' @source Generated sample data for testing purposes
"test_dat"

#' Variable Labels Dataset
#'
#' A dataset containing variable labels for survey questions.
#'
#' @format A tibble with 2 rows and 2 columns:
#' \describe{
#'   \item{variable}{Variable name in the survey dataset}
#'   \item{label}{Descriptive label for the variable}
#' }
#'
#' @source Generated sample data for testing purposes
"new_dat_var_labels"

#' Value Labels Dataset
#'
#' A dataset containing value labels for categorical survey responses.
#'
#' @format A tibble with 4 rows and 3 columns:
#' \describe{
#'   \item{variable}{Variable name in the survey dataset}
#'   \item{value}{Numeric value of the response}
#'   \item{value label}{Descriptive label for the response value}
#' }
#'
#' @source Generated sample data for testing purposes
"new_dat_val_labels"
