## code to prepare `new_dat_val_labels` dataset goes here
new_dat_val_labels <- tibble::tribble(
  ~variable, ~value, ~`value label`,
  "q1", 1, "q1 label 1",
  "q1", 2, "q1 label 2",
  "q1", 3, "q1 label 3",
  "q1", 4, "q1 label 4"
)

usethis::use_data(new_dat_val_labels, overwrite = TRUE)
