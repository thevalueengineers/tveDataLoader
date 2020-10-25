## load spss sav file
read_sav <- function(filepath) {
  dat <- haven::read_sav(filepath)

  ## variable names to lower
  names(dat) <- stringr::str_to_lower(names(dat))

  return(dat)
}
