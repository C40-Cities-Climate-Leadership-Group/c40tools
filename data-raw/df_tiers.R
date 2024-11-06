## code to prepare `df_tiers` dataset goes here
df_tiers <- readxl::read_excel("data-raw/capacity_tiers.xlsx")


usethis::use_data(df_tiers, overwrite = TRUE)

devtools::document()
devtools::load_all()
