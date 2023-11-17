#' Extract value labels from a tibble with haven_labelled columns
#'
#' @param datafile A tibble created by reading in an SPSS .sav file using the haven package
#'
#' @export
get_valLabels <- function(datafile) {
  purrr::map(test_dat, labelled::val_labels) |>
    purrr::map(tibble::enframe, name = "value label") |>
    purrr::map_dfr(~if(nrow(.x) > 0) {.x} else {NULL}, .id = "variable") |>
    dplyr::select(variable, value, `value label`)
}



