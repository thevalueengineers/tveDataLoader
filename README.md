
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tveDataLoader

<!-- badges: start -->
<!-- badges: end -->

Load spss .sav data and perform basic data checks in a TVE manner.

## Installation

Install from github:

``` r
renv::install("thevalueengineers/tveDataLoader")
```

## Example

`tve_path` converts paths to egnyte between Windows and MacOS formats.

``` r
# Run on MacOS:
tve_path("Z:/shared/TVE Data/1. Client Projects/")
#> [1] "/Users/jameshawes/Library/CloudStorage/Egnyte-thevalueengineers/shared/TVE Data/1. Client Projects/"
```

`read_sav` is a wrapper around `haven::read_sav` that also converts all
variable names to lower case for consistency. Use it instead of
`haven::read_sav` and try to avoid loading the `haven` package into
projects.

Load spss data with `read_sav` and `tve_path`:

``` r
library(tveDataLoader)
read_sav(
  paste0(
    tve_path(path_to_file),
    "filename.sav"
  )
)
```

`run_data_checks` performs basic data checks and exploration on your
data.

``` r
tibble::tibble(
  respid = 1:10,
  weight = rep(1, 10),
  q1 = sample(1:5, 10, replace = TRUE)
) |> 
  run_data_checks()
#> Checking for unique ID
#> Checking for weight variable
#> Possible weight variable found: weight
#> Summarise weight variable(s)
#> $unique_id
#> [1] "respid"
#> 
#> $weight_var
#> [1] "weight"
#> 
#> $weight_summary
#> # A tibble: 1 × 9
#>   variable  mean median   var    sd   min   max missing missing_percent
#>   <chr>    <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl>   <int>           <dbl>
#> 1 weight       1      1     0     0     1     1       0               0
```
