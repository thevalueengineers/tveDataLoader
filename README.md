
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
#> Checking for presence of vars
#> $data
#> # A tibble: 10 × 3
#>    respid weight    q1
#>     <int>  <dbl> <int>
#>  1      1      1     4
#>  2      2      1     2
#>  3      3      1     1
#>  4      4      1     2
#>  5      5      1     5
#>  6      6      1     5
#>  7      7      1     4
#>  8      8      1     5
#>  9      9      1     5
#> 10     10      1     3
#> 
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
#> 
#> $vars_check
#> NULL
```

Use `update_var_labels` and `update_val_labels` to change variable and
value labels respectively.

``` r
nresps <- 5
dat <- tibble(
  var1 = sample(1:3, nresps, replace = TRUE),
  var2 = sample(0:1, nresps, replace = TRUE)
)

new_var_labels <- tribble(
  ~variable, ~value,
  "var1", "Variable 1",
  "var2", "Variable 2"
)

new_val_labels <- tribble(
  ~variable, ~value, ~`value label`,
  "var1", 1, "value 1",
  "var1", 2, "value 2",
  "var1", 3, "value 3",
  "var2", 0, "no",
  "var2", 1, "yes"
)

dat |> 
  update_var_labels(new_var_labels) |> 
  update_val_labels(new_val_labels)
#> # A tibble: 5 × 2
#>   var1        var2     
#>   <int+lbl>   <int+lbl>
#> 1 1 [value 1] 1 [yes]  
#> 2 3 [value 3] 1 [yes]  
#> 3 3 [value 3] 1 [yes]  
#> 4 3 [value 3] 1 [yes]  
#> 5 1 [value 1] 0 [no]
```
