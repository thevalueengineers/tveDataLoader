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
)
