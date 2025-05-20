#' Generate an OS specific TVE filepath
#'
#' Paths on macOS don't use named drives, meaning a filepath from a Windows
#' machine won't work on macOS and vice versa. This function should translate
#' between the two, though primarily from Windows to Mac.
#'
#' @param path File path to be converted
#' @param dtag_company whether file path is for tve or 2cv
#'
#' @export
tve_path <- function(path,
                     dtag_company = "tve") {

  if (dtag_company == "tve") {
  if(.Platform$OS.type == "unix") {
    # if unix then replace Z:/ in the filepath
    gsub(
      "Z:/",
      paste0(
        "/Users/",
        Sys.info()["user"],
        "/Library/CloudStorage/Egnyte-thevalueengineers/"
      ),
      path
    )
  } else if (.Platform$OS.type == "windows") {
    # replace /Users/.../Egnyte-thevalueengineers/
    gsub(
      "/Users.*Egnyte-thevalueengineers/",
      "Z:/",
      path
    )
  }
}
  else if (dtag_company == "2cv") {
    # if not tve then return the path as is
    if(.Platform$OS.type == "unix") {
      # if unix then replace Z:/ in the filepath
      gsub(
        "Z:/",
        paste0(
          "/Users/",
          Sys.info()["user"],
          "/Library/CloudStorage/Egnyte-2cv"
        ),
        path
      )
    } else if (.Platform$OS.type == "windows") {
      # replace /Users/.../Egnyte-thevalueengineers/
      gsub(
        "/Users.*Egnyte-2cv/",
        "Z:/",
        path
      )
    }
  }
  }
