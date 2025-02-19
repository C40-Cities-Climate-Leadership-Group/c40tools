
<!-- README.md is generated from README.Rmd. Please edit that file -->

# C40 <img src='docs/logo.png' align="right" height="200" style="float:right; height:200px;" />

<!-- badges: start -->

[![R build
status](https://github.com/C40-Cities-Climate-Leadership-Group/c40tools/workflows/R-CMD-check/badge.svg)](https://github.com/C40-Cities-Climate-Leadership-Group/c40tools/actions)
[![Coverage
status](https://codecov.io/gh/C40-Cities-Climate-Leadership-Group/c40tools/branch/master/graph/badge.svg)](https://app.codecov.io/gh/C40-Cities-Climate-Leadership-Group/c40tools?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/c40tools)](https://cran.r-project.org/package=c40tools)
[![](http://cranlogs.r-pkg.org/badges/grand-total/c40tools?color=blue)](https://cran.r-project.org/package=c40tools)
[![](http://cranlogs.r-pkg.org/badges/last-month/c40tools?color=blue)](https://cran.r-project.org/package=c40tools)

<!-- badges: end -->

# Toolbox for data processing in C40

## Description

If you want to process and visualize data in [C40](https://www.c40.org/)
using the programming language [R](https://www.r-project.org/), the
`c40tools` library is intended to make your job easier.

The package plays a fundamental role in democratising the possibility to
process data in the organisation. With `c40tools` you will be able to
access the official C40 data and automatically connect to the Data
Warehouse, as well as access a set of functions to facilitate the data
cleansing process. Finally, you will also be able to facilitate the data
visualisation process through functions that allow you to adopt the
organisation’s official style manual.

Some of its main functions include:

- **`get_dw_connection()`**: Get connected to the C40 Data Warehouse,

- **`get_dw_db_example()`**: Code examples for accesing the data from
  the Data Warehouse,

- **`c40_colors()`**: Get C40 official colors

- **`scale_fill_c40()`**: C40 Scale color for filling

- **`scale_color_c40()`**: C40 border color scale

- **`clean_text()`**: Removes accents and umlaut from vowels. E.g.:
  “ÿÚòâ” into “yUoa”.

- **`get_googledrive_path()`**: Get your local Google Drive folder

## Installation

For the development version

``` r
# install.packages('devtools')
# if you do not have devtools installed

devtools::install_github("C40-Cities-Climate-Leadership-Group/c40tools")

# or
remotes::install_github("C40-Cities-Climate-Leadership-Group/c40tools")
```

## How to use

How to get access to the Data Warehouse:

First we need to configure the keys necessary for the connection to the
Data Warehouse on our computers (one time only). To do this we must set
them in the .Renviron file, which can be edited with the
`usethis::edit_r_environ()` function. When executing this sentence, the
file will be opened and the following variables must be defined in it:

    DATAWAREHOUSE_HOST=""
    DATAWAREHOUSE_USER="c40_user"
    DATAWAREHOUSE_PASSWORD=""

Once set, we will have the connection enabled to simply run:

``` r
library(c40tools)

con <- get_dw_connection()
```

Once the connection is established, we can proceed to extract the data.
The `get_dw_db_example()` function can assist us with syntax examples to
extract a specific dataset:

- Example of syntax executing SQL code from R:

``` r
get_dw_db_example(type = 'sql')
#> This is an example of how to download a table from the dw via an sql request 
#> 
#> df <- tbl(con,
#>                                  sql("
#>                        SELECT * FROM dim_cities
#>                        LEFT JOIN fact_city_modelled_emissions
#>                        ON dim_cities.city_id = fact_city_modelled_emissions.city_id
#>                        ")) |>
#>             collect())
```

- Example syntax providing the name of the specific dataset:

``` r
get_dw_db_example(type = 'table')
#> This is an example of how to download a table from the dw 
#> 
#> df <- tbl(con,
#>                          Id(schema = "public",
#>                             table = "fact_city_modelled_emissions")) |>
#>     collect()
```

## How to cite this package

You can cite this package as ‘C40 Cities data were obtained and/or
normalised using the R package “c40tools” (C40 et al, 2024)’.

The full reference for inclusion in the bibliography is:

    C40 Cities (2024). R package version [doi version]

## Community input

This package aims to incorporate any general purpose functions that use
C40 data as a basis.

If you are working with C40 Cities data and want to add your function,
we recommend that you read the following
[tips](https://github.com/C40-Cities-Climate-Leadership-Group/c40tools/blob/master/.github/CONTRIBUTING.md)
on how to contribute
