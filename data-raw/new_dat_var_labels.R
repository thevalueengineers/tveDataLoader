## code to prepare `new_dat_var_labels` dataset goes here
new_dat_var_labels <- tibble::tribble(
  ~variable, ~label,
  "q1", "q1 label",
  "q1.1", "q1.1 label"
)

usethis::use_data(new_dat_var_labels, overwrite = TRUE)
