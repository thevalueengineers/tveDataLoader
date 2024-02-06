#' Data checking functions
#'
#' Performs standard data checks on survey data. Doesn't alter the data in any
#' way, just reports on potential data quality concerns.
#'
#' @param data Data frame to be tested.
#' @param vars Optional character vector of variable names to be tested within
#'   data
#' @param unique_id Logical. Whether to run the unique_id check. Default is
#'   TRUE.
#' @param quiet Whether to display messages in the console. Default is true.
#'
#' @export
run_data_checks <- function(data,
                            vars = NULL,
                            unique_id = TRUE,
                            quiet = FALSE) {

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
  purrr::iwalk(
    list(
      unique_id = unique_id,
      quiet = quiet
    ),
    ~assertthat::assert_that(
      is.logical(.x),
      msg = glue::glue("{.y} must be TRUE or FALSE")
    )
  )

  # if no vars provided then use all ----
  if(is.null(vars)) {vars <- names(data)}

  # check for a unique ID ----
  if(unique_id) {
    if(!quiet) message("Checking for unique ID")
    id_check <- purrr::map_lgl(vars, ~length(unique(data[[.x]])) == nrow(data))
    if(sum(id_check) == 0) {
      if(!quiet) message("No unique ID")
      unique_id <- "No ID"
    } else if(sum(id_check) == 1) {
      if(!quiet) (glue::glue("ID variable found: {vars[id_check]}"))
      unique_id <- vars[id_check]
    } else {
      if(!quiet) {
        print(
          glue::glue(
            "Multiple potential ID variables found: {stringr::str_flatten_comma(vars[id_check])}"
          )
        )
      }
      unique_id <- vars[id_check]
    }
  } else {
    unique_id <- "Check not run"
  }

  # return check results ----
  return(
    list(
      unique_id = unique_id
    )
  )
}
