#' Extract value labels from a tibble with haven_labelled columns
#'
#' @param datafile A tibble created by reading in an SPSS .sav file using the haven package
#'
#' @export
get_valLabels <- function(datafile) {
  purrr::map(datafile, labelled::val_labels) %>%
    unlist() %>%
    tibble::enframe(name = "variable") %>%
    tidyr::separate(
      variable,
      into = c("variable", "value label"),
      sep = "\\.",
      extra = "merge"
    ) %>%
    dplyr::select(variable, value, `value label`)
}
