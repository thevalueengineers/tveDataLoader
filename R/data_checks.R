#' Data checking functions
#'
#' Performs standard data checks on survey data. Doesn't alter the data in any
#' way, just reports on potential data quality concerns.
#'
#' @param data Data frame to be tested.
#' @param vars Optional character vector of variable names to be tested within
#'   data. Default is NULL, i.e. test all variables.
#' @param unique_id Logical. Whether to run the unique_id check. Default is
#'   `TRUE`.
#' @param weight Either a logical to check for a weight var, or the name of the
#'   weight variable on which to run a summary. Default is `TRUE`.
#' @param quiet Whether to display messages in the console. Default is true.
#'
#' @returns List of check outcomes:
#'  \itemize{
#'   \item{"unique_id": Names of variables identified as possible unique identifiers}
#'   \item{"weight_var": Names of variables identified as possible weight variables}
#'   \item{"weight_summary": Tibble of summary stats on possible weight variables}
#'   \item{"vars_check": Character vector of variables in `vars` that are NOT present in `data`}
#'   }
#'
#' @export
run_data_checks <- function(data,
                            vars = NULL,
                            unique_id = TRUE,
                            weight = TRUE,
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
  assertthat::assert_that(
    any(is.logical(weight), is.character(weight)),
    msg = "weight must be either TRUE / FALSE or a string of variable names"
  )

  # unique_id, weight and status checks should be on the whole data set, not
  # just the specified vars
  all_vars <- names(data)

  # check for a unique ID ----
  if(unique_id) {
    unique_id <- check_for_unique_id(data, all_vars, quiet)
  } else {
    unique_id <- "Check not run"
  }

  # check for weight var ----
  weight_var <- check_for_weight(weight, data, all_vars, quiet)

  # if we have a weight_var then summarise
  if(!"No weight variable found" %in% weight_var) {
    weight_summary <- summarise_weight_var(weight_var, data, quiet)
  } else {
    weight_summary <- NULL
  }

  # check for vars ----
  vars_check <- check_for_vars(data, vars, quiet)


  # return check results ----
  return(
    list(
      unique_id = unique_id,
      weight_var = weight_var,
      weight_summary = weight_summary,
      vars_check = vars_check
    )
  )
}



#' Check for presence of unique ID
#'
#' Checks `vars` to see if any are unique for each row. Returns the variable
#' name or names if more than 1 potential unique ID are found.
#'
#' @inheritParams run_data_checks
#' @param vars Variable names to check
#'
#' @returns Character vector of the potential unique ID variable(s) names or "No
#'   ID" if none are found.
#'
#' @export
check_for_unique_id <- function(data, vars, quiet = FALSE) {

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
          "Multiple potential ID variables found: \\
            {stringr::str_flatten_comma(vars[id_check])}"
        )
      )
    }
    unique_id <- vars[id_check]
  }

  return(unique_id)
}

#' Checks variable names for a potential weight variable
#'
#' Searches for a variable name that includes "weight" in the variable names
#' provided. If none found it will return "No weight variable found", otherwise
#' it will return the variable names that match.
#'
#' @inheritParams run_data_checks
#' @param vars Character vector of variable names to be checked.
#'
#' @returns Character vector of potential weight variable names or "No weight
#'   variable found" if no potential weight variable identified.
#'
#' @export
check_for_weight <- function(weight = TRUE, data, vars, quiet = FALSE) {
  if(!quiet) message("Checking for weight variable")

  # if weight is logical then we want to search / not search for a weight
  # variable dependent on its value
  if(is.logical(weight)) {
    if(weight) { # if weight == TRUE then search for a weight variable
      # is there an obvious weight in the data
      weight_var <- vars[grepl("weight", vars)]

      if(length(weight_var) == 0) {
        weight_var <- "No weight variable found"
        if(!quiet) message("No weight variable found")
      } else if (length(weight_var) == 1) {
        if(!quiet) message(
          glue::glue("Possible weight variable found: {weight_var}")
        )
      } else {
        if(!quiet) message(
          glue::glue(
            "Multiple possible weight variables found: \\
            {stringr::str_flatten_comma(weight_var)}"
          )
        )
      }
    } else { # if weight != TRUE then don't search
      weight_var <- "Check not run"
    }
  } else {
    # weight must be a character vector so check it's in the data
    if(!quiet) message(glue::glue("Checking for {weight} in data"))
    if(weight %in% names(data)) {
      if(!quiet) message(glue::glue("{weight} found"))
      weight_var <- weight
    } else {
      if(!quiet) message(glue::glue("{weight} is not a variable in data"))
      weight_var <- "No weight variable found"
    }
  }

  return(weight_var)
}

#' Run summary statistics on weight variable
#'
#' @inheritParams run_data_checks
#' @param weight_var Character vector of weight variable names in `data` to be summarised.
#' @param data Dataframe that contains `weight_var`(s).
#'
#' @returns A tibble of summary statistics with 1 row per `weight_var`.
#'
#' @export
summarise_weight_var <- function(weight_var, data, quiet = FALSE) {
  if(!quiet) message("Summarise weight variable(s)")
  weight_summary <- data |>
    dplyr::select(dplyr::all_of(weight_var)) |>
    # pivot in case there is more than 1 weight variable
    tidyr::pivot_longer(everything(), names_to = "variable") |>
    dplyr::group_by(variable) |>
    dplyr::summarise(
      # na.rm deliberately left as FALSE so that if there are missing weights
      # NAs are shown
      mean = mean(value),
      median = median(value),
      var = var(value),
      sd = sd(value),
      min = min(value),
      max = max(value),
      missing = sum(is.na(value)),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      missing_percent = missing / nrow(data)
    )

  # flag if some rows are missing weights
  if(!quiet & max(weight_summary$missing) > 0) {
    weight_summary |>
      dplyr::filter(missing > 0) |>
      dplyr::select(variable, missing) |>
      dplyr::mutate(message = glue::glue("{variable} has {missing} rows with no weight

                                           ")) |>
      dplyr::pull(message) |>
      message()
  }

  return(weight_summary)
}

#' Checks for presence of `vars` in `data`
#'
#' @inheritParams run_data_checks
#' @param vars Character vector of variable names. `data` will be checked for
#'   the presence of each variable
#'
#' @export
check_for_vars <- function(data, vars, quiet = FALSE) {
  if(!quiet) message("Checking for presence of vars")
  not_in_data <- vars[!vars %in% names(data)]

  if(!quiet & length(not_in_data) > 0) {
    message(glue::glue("{length(not_in_data)} vars not found in data: {stringr::str_flatten_comma(not_in_data)}"))
  } else if (!quiet & length(not_in_data == 0)) {
    message("All vars found")
  }

  return(not_in_data)
}
