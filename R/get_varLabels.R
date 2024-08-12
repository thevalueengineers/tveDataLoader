#' extract variable labels from a tibble with haven_labelled columns
#'
#' @param datafile A tibble created by reading in an SPSS .sav file using the haven package
#'
#' @export
get_varLabels <- function(datafile) {
  assertthat::assert_that(
    is.data.frame(datafile),
    msg = "datafile must be a dataframe"
  )

  lapply(datafile, labelled::var_label) |>
    unlist() |>
    tibble::enframe(name = "variable", value = "label")
}
