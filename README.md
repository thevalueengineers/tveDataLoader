
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tveDataLoader

<!-- badges: start -->

[![R-CMD-check](https://github.com/thevalueengineers/tveDataLoader/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/thevalueengineers/tveDataLoader/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/thevalueengineers/tveDataLoader/graph/badge.svg?token=31TXY5ABMX)](https://codecov.io/gh/thevalueengineers/tveDataLoader)

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
#> [1] "/Users/juanhernandez/Library/CloudStorage/Egnyte-thevalueengineers/shared/TVE Data/1. Client Projects/"
```

### Loading SPSS Data

The package provides enhanced functionality for loading SPSS (.sav)
files through the `load_sav()` function. This function not only loads
the data but also extracts and organizes variable and value labels,
making it easier to work with SPSS metadata.

#### Basic Usage

``` r
library(tveDataLoader)

# Basic data loading with automatic key creation
loaded_data <- load_sav(
  paste0(
    tve_path(path_to_file),
    "filename.sav"
  )
)

# The loaded_data object is a list containing:
# - loaded_data$loaded_data: The actual dataset (with labels removed)
# - loaded_data$var_labels: Variable labels
# - loaded_data$val_labels: Value labels
# - loaded_data$no_var_labels: Variables without variable labels
# - loaded_data$no_val_labels: Variables without value labels
```

#### Key Variable Management

The `load_sav()` function provides flexible options for managing key
variables in your dataset:

``` r
# Option 1: Create a sequential key variable with default name "respid"
loaded_data <- load_sav("filename.sav")

# Option 2: Create a sequential key variable with custom name
loaded_data <- load_sav("filename.sav", keyv_name = "participant_id")

# Option 3: Use existing variable(s) as key(s)
loaded_data <- load_sav("filename.sav", keyv = c("id", "wave"))
```

#### Additional Options

``` r
# Omit specific columns and set custom key
loaded_data <- load_sav(
  "filename.sav",
  keyv_name = "id",
  col_omit = c("sensitive_var", "temp_var")
)

# Use data.table format instead of tibble
loaded_data <- load_sav(
  "filename.sav",
  tibble_out = FALSE
)

# Sort data by key variables
loaded_data <- load_sav(
  "filename.sav",
  keyv = c("region", "respondent_id"),
  sort_by_key = TRUE
)
```

#### Key Variable Behavior

The function handles key variables intelligently:

- **Default behavior**: Creates a sequential key variable named “respid”
- **Custom key name (`keyv_name`)**:
  - If variable exists in data: uses it as the key
  - If variable doesn’t exist: creates new sequential key with that name
- **Explicit key variables (`keyv`)**: Uses specified existing variables
  as keys
- **Data sorting**: When `sort_by_key = TRUE`, data is sorted by the key
  variable(s)

> Note: The older `read_sav()` function has been superseded by
> `load_sav()` which provides enhanced functionality for handling SPSS
> data and metadata.

### Data Checks

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
#>  2      2      1     4
#>  3      3      1     3
#>  4      4      1     3
#>  5      5      1     1
#>  6      6      1     2
#>  7      7      1     1
#>  8      8      1     4
#>  9      9      1     3
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

### Updating Labels

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
#> 1 2 [value 2] 1 [yes]  
#> 2 2 [value 2] 0 [no]   
#> 3 3 [value 3] 1 [yes]  
#> 4 1 [value 1] 0 [no]   
#> 5 1 [value 1] 0 [no]
```
