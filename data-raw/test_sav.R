## code to prepare `test_sav` dataset goes here

set.seed(1)
test_sav <- tibble::tibble(
  respid = labelled::labelled(1:100,
                              label = 'respid'),
  lab_var1 = labelled::labelled(
    sample(1:4, 100, replace = TRUE),
    labels = c(
      "A" = 1,
      "B" = 2,
      "C" = 3,
      "D" = 4
    ),
    label = "v1 label"
  ),
  lab_var2 = labelled::labelled(
    sample(1:4, 100, replace = TRUE),
    labels = c(
      "a" = 1,
      "b" = 2
    ),
    label = "v2 label"
  ),
  num_var1 = rnorm(100),
  char_var1 = sample(letters, 100, replace = TRUE),
  lab_var3 = labelled::labelled(
    sample(letters[4:6], 100, replace = TRUE),
    labels = c(
      "d" = "letter d",
      "e" = "letter e",
      "f" = "letter f"
    )
  )
)

# Save the dataset as a .sav file
haven::write_sav(test_sav,
                 path = here::here('inst', 'extdata', 'test_sav.sav'))

usethis::use_data(test_sav, overwrite = TRUE)
