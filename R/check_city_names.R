#' Check if city column names match the C40 curated list of city names
#'
#' Compares city names in a data frame against the official C40 city names
#' from the Data Warehouse, with optional cleaning and ID matching.
#'
#' @param df A data frame containing a column with city names.
#' @param city_var_name Character. Name of the column containing city names.
#' @param clean_city_name Logical. If \code{TRUE}, applies cleaning rules to
#'   standardise city names. Default is \code{FALSE}.
#' @param want_cityid Logical. If \code{TRUE}, returns the data frame with an
#'   additional \code{city_id} column for linking with the Data Warehouse.
#'   Default is \code{FALSE}.
#'
#' @return If \code{clean_city_name = FALSE}, returns a comparison object
#'   (from \code{waldo::compare}) showing differences between input city names
#'   and official C40 city names. If \code{clean_city_name = TRUE}, returns the
#'   input data frame with standardised city names.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Compare city names against official list
#' check_city_names(my_data, "city_name")
#'
#' # Clean and standardise city names
#' cleaned_data <- check_city_names(my_data, "city_name", clean_city_name = TRUE)
#'
#' # Clean and add city_id for Data Warehouse linking
#' cleaned_data <- check_city_names(my_data, "city_name",
#'                                   clean_city_name = TRUE,
#'                                   want_cityid = TRUE)
#' }
check_city_names <- function(df, city_var_name, clean_city_name = FALSE, want_cityid = FALSE) {

 con <- get_dw_connection()
 on.exit(DBI::dbDisconnect(con), add = TRUE)

 df_cities <- dplyr::tbl(con,
                          DBI::Id(schema = "public",
                                  table = "dim_cities")) |>
 dplyr::filter(current_member == TRUE) |>
 dplyr::select(city, city_id) |>
 dplyr::collect()

 # Set the city column name as city
 city_col_position <- which(colnames(df) == city_var_name)
 colnames(df)[city_col_position] <- "city"

 if (!clean_city_name) {

 df_1 <- sort(unique(df_cities$city))
 df_2 <- sort(unique(df$city))

 city_names_check <- waldo::compare(df_1, df_2)

 return(city_names_check)

 } else {

 df <- df |>
   dplyr::mutate(
 city_stage1 = tolower(clean_text(city)),
 new_city_name = dplyr::case_when(
   city_stage1 == "ciudad de mexico" ~ "Mexico City",
   city_stage1 == "pretoria" ~ "Tshwane",
   city_stage1 == "hong kong, china" ~ "Hong Kong",
   city_stage1 == "tel aviv" ~ "Tel Aviv-Yafo",
   city_stage1 == "metropolitan municipality of lima" ~ "Lima",
   city_stage1 == "municipio de lisboa" ~ "Lisbon",
   city_stage1 == "su paulo" ~ "Sao Paulo",
   .default = city
 )
   ) |>
   dplyr::select(-city, -city_stage1) |>
   dplyr::relocate(city = new_city_name)

 if (!want_cityid) {

   return(df)

 } else {

   df <- df |>
 dplyr::left_join(df_cities, by = "city") |>
 dplyr::relocate(city_id)

   return(df)
 }
 }
}


# Internal helper function: find closest match with distance threshold
# @keywords internal
find_closest_match <- function(city, valid_cities, threshold = 0.2) {

 distances <- stringdist::stringdist(city, valid_cities, method = "jw")
 min_distance <- min(distances)

 if (min_distance < threshold) {
 closest_match <- valid_cities[which.min(distances)]
 } else {
 closest_match <- NA
 }

 return(closest_match)
}

# Internal helper function: check if any character in city matches valid cities
# @keywords internal
check_character_match <- function(city, valid_cities) {

 any(sapply(valid_cities, function(valid_city) {
 any(strsplit(city, NULL)[[1]] %in% strsplit(valid_city, NULL)[[1]])
 }))
}

#' Clean and correct city names using fuzzy matching
#'
#' Applies fuzzy string matching to correct city names against the official

#' C40 city list. Useful for cleaning data from external sources with
#' inconsistent city naming conventions.
#'
#' @param df A data frame containing a column with city names.
#' @param city_column_name Name of the column containing city names (unquoted).
#' @param valid_cities Character vector of valid C40 city names to match against.
#' @param want_cityid Logical. If \code{TRUE}, returns the data frame with an
#'   additional \code{city_id} column. Default is \code{TRUE}.
#' @param threshold Numeric. Maximum Jaro-Winkler distance for matching.
#'   Lower values require closer matches. Default is 0.2.
#'
#' @return A data frame with corrected city names in a new \code{corrected_city}
#'   column. If \code{want_cityid = TRUE}, also includes \code{city_id}.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' valid_cities <- get_c40cities()$city
#' corrected_data <- check_and_correct_cities(my_data, city_name, valid_cities)
#' }
check_and_correct_cities <- function(df, city_column_name, valid_cities, want_cityid = TRUE, threshold = 0.2) {

 df <- df |>
 dplyr::filter(sapply({{ city_column_name }}, check_character_match, valid_cities = valid_cities)) |>
 dplyr::mutate(
   # Clean the city names
   {{ city_column_name }} := stringr::str_remove_all({{ city_column_name }}, "District of |City of|City District Government|Distrito Capital|Ville de"),
   {{ city_column_name }} := stringr::str_remove_all({{ city_column_name }}, "Metropolitan Administration|City Administration|Metropolitan Municipality"),
   {{ city_column_name }} := stringr::str_remove_all({{ city_column_name }}, "Distrito Metropolitano de|Municipality|Government|Metropolitan Area"),
   {{ city_column_name }} := stringr::str_remove_all({{ city_column_name }}, "Prefeitura de|Prefeitura do|Region Metropolitana|The Local Government"),
   {{ city_column_name }} := stringr::str_remove_all({{ city_column_name }}, "Special Administrative Region|Greater|Authority|of|Region Metropolitana de"),
   {{ city_column_name }} := stringr::str_remove_all({{ city_column_name }}, "Metropolitan|The Local  of |of|Municipal People's|Special Administrative Region"),
   {{ city_column_name }} := stringr::str_remove_all({{ city_column_name }}, "The Local"),
   {{ city_column_name }} := stringr::str_trim({{ city_column_name }}),
   # Correct the city names
   corrected_city = sapply({{ city_column_name }}, find_closest_match, valid_cities = valid_cities, threshold = threshold),
   corrected_city = dplyr::case_when(
 stringr::str_detect(corrected_city, "eThekwini") ~ "Durban (eThekwini)",
 .default = corrected_city
   )
 )

 if (want_cityid) {

 df <- df |>
   dplyr::left_join(get_c40cities(),
                     by = c("corrected_city" = "city")) |>
   dplyr::relocate(city_id, city)

 return(df)

 } else {
 return(df)
 }
}
