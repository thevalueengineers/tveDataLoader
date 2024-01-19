test_that("converting filepaths works", {
  test_path <- ifelse(
    .Platform$OS.type == "unix",
    "Z:/shared/",
    paste0("/Users/", Sys.info()["user"], "/shared/")
  )
  expect_true(dir.exists(tve_path("Z:/shared")))
  expect_true(
    dir.exists(
      tve_path(
        paste0(
          "/Users/",
          Sys.info()["user"],
          "/Library/CloudStorage/Egnyte-thevalueengineers/shared"
          )
        )
      )
  )
})
