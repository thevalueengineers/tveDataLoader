#' Generate an OS specific TVE filepath
#'
#' Paths on macOS don't use named drives, meaning a filepath from a Windows
#' machine won't work on macOS and vice versa. This function should translate
#' between the two, though primarily from Windows to Mac.
#'
#' @param path File path to be converted
#'
#' @export
tve_path <- function(path) {
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
