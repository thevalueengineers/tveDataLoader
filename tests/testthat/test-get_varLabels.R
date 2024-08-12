test_that("input validation works", {
  expect_error(
    get_varLabels(haven::labelled(1:2, label = "label1"))
  )
})
test_that("correct labels are returned", {
  expect_equal(
    get_varLabels(test_dat),
    tibble::tibble(variable = c("q1", "q1.1"), label = rep("Test label", 2))
  )
}
)
test_that("empty tibble returned when there are no labels", {
  expect_equal(
    haven::zap_label(test_dat) |>
      get_varLabels(),
    tibble::tibble(variable = integer(), label = logical())
  )
})
