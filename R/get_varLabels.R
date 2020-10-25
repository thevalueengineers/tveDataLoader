## extract variable labels from tibble read in via tveDataLoader::read_sav
get_varLabels <- function(datafile) {
  purrr::map(datafile, labelled::var_label) %>%
    unlist() %>%
    tibble::enframe(name = "variable", value = "label")
}
