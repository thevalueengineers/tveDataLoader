#' Read in SPSS .sav files and convert variable names to lower case
#'
#' Wrapper around haven::read_sav() and stringr::str_to_lower()
#'
#' @param filepath Character storing filepath, including filename, of the sav file to be read in
#'
#' @export
read_sav <- function(filepath) {
  dat <- haven::read_sav(filepath)

  ## variable names to lower
  names(dat) <- stringr::str_to_lower(names(dat))

  return(dat)
}
