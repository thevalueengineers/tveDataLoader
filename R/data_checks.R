#' Data checking functions
#'
#' Performs standard data checks on survey data. Doesn't alter the data in any
#' way, just reports on potential data quality concerns.
run_data_checks <- function(data,
                            vars = NULL) {

  # input validation ----
  assertthat::assert_that(
    is.data.frame(data),
    msg = "data must be a data frame"
  )
  if(!is.null(vars)) {
    assertthat::assert_that(
    is.character(vars),
    msg = "vars must be a character string"
    )
  }

  # if no vars provided then use all ----
  if(is.null(vars)) {vars = names(data)}

  # check for a unique ID ----

}
