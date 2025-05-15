[[_TOC_]]

# Overview

The [`tveDataLoader`](https://github.com/thevalueengineers/tveDataLoader) package provides standardized tools for loading, checking, and manipulating survey data, with a focus on SPSS (.sav) files. It's designed to streamline data processing workflows at DTAG by providing consistent approaches to common data tasks.

# Key Features

## Data Loading

- **`load_sav()`**: The primary function for loading SPSS data files. It provides enhanced functionality:
  - Automatically converts variable names to lowercase and cleans them
  - Extracts and organizes variable and value labels
  - Returns a structured list containing the dataset and its metadata
  - Options to set key variables and omit specific columns
- **`read_sav()`**: *(Superseded)* A basic wrapper around `haven::read_sav()` that converts variable names to lowercase
- **`tve_path()`**: Converts file paths between Windows and macOS formats for seamless cross-platform compatibility with Egnyte cloud storage

## Data Inspection

- **`run_data_checks()`**: Performs standard quality checks on survey data:
  - Identifies unique ID variables
  - Detects and summarizes weight variables
  - Verifies the presence of specified variables
  - Returns a structured list of check results without modifying the data

## Label Management

- **`get_varLabels()`**: Extracts variable labels from a tibble with haven_labelled columns
- **`get_valLabels()`**: Extracts value labels from a tibble with haven_labelled columns
- **`update_var_labels()`**: Updates variable labels using a standardized format
- **`update_val_labels()`**: Updates value labels using a standardized format

## Included Datasets

The package includes sample datasets for testing and demonstration:

- **`test_dat`**: A sample dataset with 100 rows and 4 columns including labelled variables
- **`new_dat_var_labels`**: A sample variable labels dataset
- **`new_dat_val_labels`**: A sample value labels dataset

# Usage Examples

## Loading SPSS Data

```r
# Convert Windows Egnyte path to macOS format
file_path <- tve_path("Z:/shared/TVE Data/1. Client Projects/")

# Load SPSS file with full metadata extraction
survey_data <- load_sav(paste0(file_path, "survey_data.sav"))

# Access components of the loaded data
data <- survey_data$loaded_data           # The actual dataset
var_labels <- survey_data$var_labels      # Variable labels
val_labels <- survey_data$val_labels      # Value labels
no_var_labels <- survey_data$no_var_labels # Variables without variable labels
no_val_labels <- survey_data$no_val_labels # Variables without value labels

# You can also specify key variables and columns to omit
survey_data <- load_sav(
  paste0(file_path, "survey_data.sav"),
  keyv = c("respid"),           # Set key variables
  col_omit = c("temp_var")     # Omit specific columns
)
```

## Running Data Checks

```r
# Perform standard data quality checks
check_results <- survey_data %>% 
  run_data_checks()

# Access specific check results
unique_id_vars <- check_results$unique_id
weight_vars <- check_results$weight_var
weight_summary <- check_results$weight_summary
```

## Working with Labels

```r
# Extract existing labels
var_labels <- get_varLabels(survey_data)
val_labels <- get_valLabels(survey_data)

# Create new label definitions
new_var_labels <- tribble(
  ~variable, ~label,
  "q1", "First question",
  "q2", "Second question"
)

new_val_labels <- tribble(
  ~variable, ~value, ~`value label`,
  "q1", 1, "Strongly disagree",
  "q1", 2, "Disagree",
  "q1", 3, "Neither agree nor disagree",
  "q1", 4, "Agree",
  "q1", 5, "Strongly agree"
)

# Update labels in the dataset
survey_data <- survey_data %>%
  update_var_labels(new_var_labels) %>%
  update_val_labels(new_val_labels)
```

# Best Practices

1. **Consistent Path Management**: Always use `tve_path()` when working with Egnyte paths to ensure cross-platform compatibility

2. **Standardized Data Loading**: Use `read_sav()` instead of `haven::read_sav()` to ensure consistent variable naming

3. **Data Quality Verification**: Run `run_data_checks()` on newly loaded datasets to identify potential issues early

4. **Label Management**: Use the label extraction and update functions to maintain consistent labeling across projects

5. **Documentation**: When creating new datasets, follow the documentation pattern used for the included sample datasets

# Installation

```r
# Install from GitHub
renv::install("thevalueengineers/tveDataLoader")
```

# Dependencies

The package relies on several key packages:
- `haven` for reading SPSS files
- `labelled` for working with variable and value labels
- `tibble` and `dplyr` for data manipulation
- `assertthat` for input validation
- `purrr` for functional programming operations
