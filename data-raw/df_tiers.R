## code to prepare `df_tiers` dataset goes here
library(dplyr)

df_tiers <- readxl::read_excel("data-raw/capacity_tiers.xlsx") |>
  dplyr::mutate(city = stringr::str_trim(city, side = "both")) |>
  check_city_names(city_var_name = "city_orig", clean_city_name = TRUE, want_cityid = TRUE) |>
  dplyr::mutate(city = stringr::str_trim(city, side = "both"))


usethis::use_data(df_tiers, overwrite = TRUE)

devtools::document()
devtools::load_all()
