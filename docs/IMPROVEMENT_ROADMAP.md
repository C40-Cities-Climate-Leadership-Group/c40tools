# c40tools - Improvement Roadmap

**Last updated:** 2025-12-16

This document describes planned improvements for the `c40tools` package, organised in incremental phases.

---

## Phase 1: Critical Fixes (Foundations)

**Objective:** Make the package installable and functional without errors.

### 1.1 Fix DESCRIPTION

```r
# Required changes:
Package: c40tools
Type: Package
Title: C40 Cities Toolset
Version: 1.0.2
Authors@R: person("Pablo", "Tiscornia", , "ptiscornia@c40.org", role = c("aut", "cre"))
Description: C40 set of tools for working with data and reporting in R.
Licence: GPL (>= 3)
Encoding: UTF-8
LazyData: true
RoxygenNote: 7.3.0
Depends:
    R (>= 4.1.0)
Imports:
    assertthat,
    DBI,
    dbplyr,
    dplyr,
    ggplot2,
    glue,
    grDevices,
    mgsub,
    RPostgres,
    stringdist,
    stringr,
    sysfonts,
    tableHTML,
    tibble,
    waldo
Suggests:
    testthat (>= 3.0.0),
    knitr,
    rmarkdown
URL: https://github.com/C40-Cities-Climate-Leadership-Group/c40tools
BugReports: https://github.com/C40-Cities-Climate-Leadership-Group/c40tools/issues
Config/testthat/edition: 3
```

### 1.2 Fix critical bug in get_c40cities()

**Before (problematic):**
```r
get_c40cities <- function(current = TRUE){
  if(exists("con")){
    con <- con
  } else {
    con <- c40tools::get_dw_connection()
  }
  # ...
}
```

**After (correct):**
```r
get_c40cities <- function(current = TRUE){
  con <- get_dw_connection()
  on.exit(DBI::dbDisconnect(con), add = TRUE)
  # ...
}
```

### 1.3 Close connections in check_city_names()

Add at the beginning of the function:
```r
con <- c40tools::get_dw_connection()
on.exit(DBI::dbDisconnect(con), add = TRUE)
```

### 1.4 Fix error message in calc_ghg_emissions()

**Lines 61-62, change:**
```r
msg = "sum_by values must be one of these: 'region' or 'tier'"
```
**To:**
```r
msg = "sum_by values must be one of these: 'region', 'tier', or 'city'"
```

---

## Phase 2: Testing Infrastructure

**Objective:** Establish testing framework for future development.

### 2.1 Configure testthat

```r
# In R, execute:
usethis::use_testthat(edition = 3)
```

### 2.2 Create basic tests

**tests/testthat/test-colours.R:**
```r
test_that("c40_colors returns correct hex values", {

expect_equal(c40_colors("green"), "#03c245")
expect_equal(c40_colors("blue"), "#23BCED")
expect_length(c40_colors(), 6)
})

test_that("c40_colors validates input", {
expect_error(c40_colors("invalid_colour"))
})
```

**tests/testthat/test-text.R:**
```r
test_that("clean_text removes accents", {
  expect_equal(clean_text("São Paulo"), "Sao Paulo")
  expect_equal(clean_text("México"), "Mexico")
  expect_equal(clean_text("Zürich"), "Zurich")
})
```

**tests/testthat/test-utils.R:**
```r
test_that("round_up works correctly", {
  expect_equal(round_up(1.35, 1), 1.4)
  expect_equal(round_up(-1.35, 1), -1.4)
  expect_equal(round_up(c(1.1, 2.2), 0), c(2, 3))
})
```

### 2.3 Configure GitHub Actions

**Create `.github/workflows/R-CMD-check.yaml`:**
```yaml
name: R-CMD-check

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  R-CMD-check:
    runs-on: ${{ matrix.config.os }}
    name: ${{ matrix.config.os }} (${{ matrix.config.r }})
    strategy:
      fail-fast: false
      matrix:
        config:
          - {os: macos-latest,   r: 'release'}
          - {os: windows-latest, r: 'release'}
          - {os: ubuntu-latest,  r: 'release'}

    steps:
      - uses: actions/checkout@v4
      - uses: r-lib/actions/setup-r@v2
        with:
          r-version: ${{ matrix.config.r }}
      - uses: r-lib/actions/setup-r-dependencies@v2
        with:
          extra-packages: any::rcmdcheck
      - uses: r-lib/actions/check-r-package@v2
```

---

## Phase 3: Robustness Improvements

**Objective:** Make functions more resilient to errors.

### 3.1 Add error handling in connections

**get_dw_connection.R:**
```r
get_dw_connection <- function() {
  # Existing validations...

  tryCatch({
    con <- DBI::dbConnect(
      RPostgres::Redshift(),
      host = Sys.getenv("DATAWAREHOUSE_HOST"),
      dbname = Sys.getenv("DATAWAREHOUSE_DBNAME", "postgres"),
      user = Sys.getenv("DATAWAREHOUSE_USER"),
      password = Sys.getenv("DATAWAREHOUSE_PASSWORD"),
      port = as.integer(Sys.getenv("DATAWAREHOUSE_PORT", "5432"))
    )

    # Verify connection
    if (!DBI::dbIsValid(con)) {
      stop("Connection established but not valid")
    }

    return(con)
  }, error = function(e) {
    stop(paste("Failed to connect to Data Warehouse:", e$message))
  })
}
```

### 3.2 Validate platform in get_googledrive_path()

```r
get_googledrive_path <- function() {
  # Validate platform
  if (Sys.info()["sysname"] != "Darwin") {
    stop("get_googledrive_path() is currently only supported on macOS")
  }

  cloud_storage_path <- file.path(path.expand("~"), "Library", "CloudStorage")

  if (!dir.exists(cloud_storage_path)) {
    stop("Google Drive folder not found. Is Google Drive installed?")
  }

  # Search for Google Drive folders
gdrive_folders <- list.files(cloud_storage_path, pattern = "^GoogleDrive-.*@c40\\.org$")

  if (length(gdrive_folders) == 0) {
    stop("No C40 Google Drive account found in ", cloud_storage_path)
  }

  if (length(gdrive_folders) > 1) {
    warning("Multiple C40 Google Drive accounts found. Using first one: ", gdrive_folders[1])
  }

  return(file.path(cloud_storage_path, gdrive_folders[1]))
}
```

### 3.3 Externalise city mappings

**Create `inst/extdata/city_name_mappings.csv`:**
```csv
variant,official_name
ciudad de mexico,Mexico City
pretoria,Tshwane
hong kong china,Hong Kong
tel aviv,Tel Aviv-Yafo
metropolitan municipality of lima,Lima
municipio de lisboa,Lisbon
```

**Modify check_city_names() to use external data:**
```r
# Load mappings from file
mappings_file <- system.file("extdata", "city_name_mappings.csv",
                              package = "c40tools")
city_mappings <- utils::read.csv(mappings_file, stringsAsFactors = FALSE)
```

---

## Phase 4: Quality Improvements

**Objective:** Improve developer and user experience.

### 4.1 Fix typos (with deprecation warnings)

**For c40_pallets → c40_palettes:**
```r
#' @rdname c40_palettes
#' @export
c40_pallets <- function(...) {
  .Deprecated("c40_palettes")
  c40_palettes(...)
}

#' Get C40 colour palettes
#' @export
c40_palettes <- function(palette = "qualitative", reverse = FALSE, ...) {
  # Current implementation...
}
```

### 4.2 Improve df_tiers documentation

```r
#' C40 Cities Capacity Tiers
#'
#' A dataset containing capacity tier classifications for C40 member cities.
#'
#' @format A data frame with the following columns:
#' \describe{
#'   \item{city}{Character. Official name of the C40 member city}
#'   \item{city_id}{Integer. Unique identifier matching the Data Warehouse}
#'   \item{tier}{Character. Capacity tier classification (1, 2, or 3)}
#'   \item{tier_description}{Character. Description of the tier level}
#' }
#'
#' @source C40 Cities Climate Leadership Group internal classification
#' @examples
#' # View tier distribution
#' table(c40tools::df_tiers$tier)
#'
#' # Get cities in tier 1
#' subset(c40tools::df_tiers, tier == "1")
"df_tiers"
```

### 4.3 Create introductory vignette

**vignettes/getting-started.Rmd:**
```markdown
---
title: "Getting Started with c40tools"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Getting Started with c40tools}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

## Introduction

c40tools provides utilities for C40 Cities data analysis...

## Setup

### Environment Variables
...

## Examples

### Connecting to the Data Warehouse
...

### Working with City Names
...

### Creating Visualisations with C40 Colours
...
```

---

## Phase 5: Advanced Optimisations

**Objective:** Improve performance and long-term maintainability.

### 5.1 Externalise SQL queries

**Create `inst/sql/ghg_emissions_query.sql`**

**Modify calc_ghg_emissions():**
```r
calc_ghg_emissions <- function(region = "all", sum_by = "city") {
  # Load query from file
  query_file <- system.file("sql", "ghg_emissions_query.sql",
                            package = "c40tools")
  targets_query <- paste(readLines(query_file), collapse = "\n")

  # Rest of the function...
}
```

### 5.2 Consider connection pooling

```r
# Use pool for efficient connection management
# Add 'pool' to Imports in DESCRIPTION

.c40_pool <- NULL

get_dw_pool <- function() {
  if (is.null(.c40_pool) || !pool::dbIsValid(.c40_pool)) {
    .c40_pool <<- pool::dbPool(
      RPostgres::Redshift(),
      host = Sys.getenv("DATAWAREHOUSE_HOST"),
      dbname = "postgres",
      user = Sys.getenv("DATAWAREHOUSE_USER"),
      password = Sys.getenv("DATAWAREHOUSE_PASSWORD"),
      port = 5432,
      minSize = 1,
      maxSize = 5
    )
  }
  return(.c40_pool)
}
```

### 5.3 Add caching for static data

```r
# Cache for city list (changes rarely)
.city_cache <- new.env(parent = emptyenv())

get_c40cities <- function(current = TRUE, use_cache = TRUE) {
  cache_key <- paste0("cities_", current)

  if (use_cache && exists(cache_key, envir = .city_cache)) {
    cache_entry <- get(cache_key, envir = .city_cache)
    # Cache valid for 1 hour
    if (difftime(Sys.time(), cache_entry$timestamp, units = "hours") < 1) {
      return(cache_entry$data)
    }
  }

  # Fetch fresh data...

  # Save to cache
  assign(cache_key,
         list(data = result, timestamp = Sys.time()),
         envir = .city_cache)

  return(result)
}
```

---

## Suggested Timeline

| Phase | Description | Complexity |
|-------|-------------|------------|
| 1 | Critical Fixes | Low |
| 2 | Testing Infrastructure | Medium |
| 3 | Robustness Improvements | Medium |
| 4 | Quality Improvements | Low |
| 5 | Advanced Optimisations | High |

---

## Success Metrics

### After Phase 1:
- [ ] Package passes `R CMD check` without errors
- [ ] Package installs correctly from GitHub

### After Phase 2:
- [ ] Test coverage > 50%
- [ ] CI/CD running on each PR

### After Phase 3:
- [ ] Functions handle errors gracefully
- [ ] DB connections always closed

### After Phase 4:
- [ ] Complete documentation
- [ ] Typos fixed

### After Phase 5:
- [ ] Performance optimised
- [ ] Queries externalised

---

## Maintenance Notes

1. **Regenerate NAMESPACE** after Roxygen changes:
   ```r
   devtools::document()
   ```

2. **Run tests** before each commit:
   ```r
   devtools::test()
   ```

3. **Check package** before releases:
   ```r
   devtools::check()
   ```

4. **Update NEWS.md** with each significant change

---

*This document should be updated as phases are completed.*
