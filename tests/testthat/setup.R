test_dat <- tibble::tibble(
  respid = 1:100,
  q1 = labelled::labelled(
    sample(1:4, 100, replace = TRUE),
    labels = c(
      "A" = 1,
      "B" = 2,
      "C" = 3,
      "D" = 4
    ),
    label = "Test label"
  ),
  q1.1 = labelled::labelled(
    sample(1:4, 100, replace = TRUE),
    labels = c(
      "A" = 1,
      "B" = 2,
      "C" = 3,
      "D" = 4
    ),
    label = "Test label"
  )
) |>
  tibble::add_column(weight = 1)

new_dat_var_labels <- tibble::tribble(
  ~variable, ~label,
  "q1", "q1 label",
  "q1.1", "q1.1 label"
)
new_dat_val_labels <- tibble::tribble(
  ~variable, ~value, ~`value label`,
  "q1", 1, "q1 label 1",
  "q1", 2, "q1 label 2",
  "q1", 3, "q1 label 3",
  "q1", 4, "q1 label 4"
)
