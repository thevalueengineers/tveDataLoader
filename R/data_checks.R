#' Data checking functions
#'
#' Performs standard data checks on survey data. Doesn't alter the data in any
#' way, just reports on potential data quality concerns.
#'
#' @param data Data frame to be tested.
#' @param vars Optional character vector of variable names to be tested within
#'   data
#' @param unique_id Logical. Whether to run the unique_id check. Default is
#'   `TRUE`.
#' @param weight Either a logical to check for a weight var, or the name of the
#'   weight variable on which to run a summary. Default is `TRUE`.
#' @param quiet Whether to display messages in the console. Default is true.
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
    if(!quiet) message("Checking for unique ID")
    id_check <- purrr::map_lgl(all_vars, ~length(unique(data[[.x]])) == nrow(data))
    if(sum(id_check) == 0) {
      if(!quiet) message("No unique ID")
      unique_id <- "No ID"
    } else if(sum(id_check) == 1) {
      if(!quiet) (glue::glue("ID variable found: {all_vars[id_check]}"))
      unique_id <- all_vars[id_check]
    } else {
      if(!quiet) {
        print(
          glue::glue(
            "Multiple potential ID variables found: \\
            {stringr::str_flatten_comma(all_vars[id_check])}"
          )
        )
      }
      unique_id <- all_vars[id_check]
    }
  } else {
    unique_id <- "Check not run"
  }

  # if weight is logical look for a weight var ----
  if(is.logical(weight)) {
    if(weight) {
      if(!quiet) message("Checking for weight variable")

      # is there an obvious weight in the data
      weight_var <- all_vars[grepl("weight", all_vars)]

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
    } else {
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

  # if we have a weight_var then summarise
  if(!"No weight variable found" %in% weight_var) {
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

    if(!quiet & max(weight_summary$missing) > 0) {
      weight_summary |>
        dplyr::filter(missing > 0) |>
        dplyr::select(variable, missing) |>
        dplyr::mutate(message = glue::glue("{variable} has {missing} rows with no weight

                                           ")) |>
        dplyr::pull(message) |>
        message()
    }
  } else {
    weight_summary <- NULL
  }


  # return check results ----
  return(
    list(
      unique_id = unique_id,
      weight_var = weight_var,
      weight_summary = weight_summary
    )
  )
}
