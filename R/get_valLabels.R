## extract value labels from tibble read in via tveDataLoader::read_sav
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
