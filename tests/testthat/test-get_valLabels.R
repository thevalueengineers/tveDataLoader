val_labs <- get_valLabels(test_dat)

test_that("returns a tibble with variable, value and value label", {
  expect_true(tibble::is_tibble(val_labs))
  expect_equal(
    names(val_labs),
    c("variable", "value", "value label")
  )
})
test_that("works correctly when '.' in variable name", {
  expect_equal(
    unique(val_labs$variable),
    c("q1", "q1.1")
  )
})
