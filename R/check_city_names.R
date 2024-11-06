#' Check if city column names matches with the C40 curated list of city names
#'
#' @param df dataframe with the city column name
#' @param city_var_name name of the column wich has the city names
#' @param clean_city_name TRUE/FALSE if you want to run a cleaning process for city names. Default as FALSE
#' @param want_cityid TRUE/FALSE if you want to return a dataframe with a city_id column, in order to link it with the Data Warehouse. Default as FALSE
#'
#' @return If clean_city_name = FALSE, returns just comparisson between the current city column names and the C40 official city names in the Data Warehouse.
#' If clean_city_name = TRUE, returns a dataframe with the correct and official city names
#' @export
check_city_names <- function(df, city_var_name, clean_city_name = FALSE, want_cityid = FALSE){

  con <- c40tools::get_dw_connection()

  df_cities <- dplyr::tbl(con,
                          DBI::Id(schema = "public",
                                  table = "dim_cities")) |>
    dplyr::filter(current_member == TRUE) |>
    dplyr::select(city, city_id) |>
    dplyr::collect()

  # Set the city columna name as city
  city_col_position <- which(colnames(df)==city_var_name)
  colnames(df)[city_col_position] <- "city"


  if(clean_city_name == FALSE){

    df_1 <- sort(unique(df_cities$city))
    df_2 <- sort(unique(df$city))

    city_names_check <- waldo::compare(df_1, df_2)

    return(city_names_check)

  } else {

    df <- df |>
      mutate(city_stage1 = tolower(c40tools::clean_text(city)),
             new_city_name = case_when(city_stage1 == "ciudad de mexico" ~ "Mexico City",
                                       city_stage1 == "pretoria" ~ "Tshwane",
                                       city_stage1 == "hong kong, china" ~ "Hong Kong",
                                       city_stage1 == "tel aviv" ~ "Tel Aviv-Yafo",
                                       city_stage1 == "metropolitan municipality of lima" ~ "Lima",
                                       city_stage1 == "municipio de lisboa" ~ "Lisbon",
                                       city_stage1 == "Sú Paulo" ~ "São Paulo",
                                       .default = city)) |>
      select(-city, -city_stage1) |>
      relocate(city = new_city_name)

    if(want_cityid == FALSE){

      return(df)

    } else {

      df <- df |>
        left_join(df_cities) |>
        relocate(city_id)

      return(df)
    }
  }
}





# Function to find the closest match with a distance threshold
find_closest_match <- function(city, valid_cities, threshold = 0.2) {

  distances <- stringdist::stringdist(city, valid_cities, method = "jw")

  min_distance <- min(distances)

  if (min_distance < threshold) {

    closest_match <- valid_cities[which.min(distances)]

  } else {

    closest_match <- NA  # Or keep the original city if preferred: closest_match <- city

  }
  return(closest_match)
}

# Function to check if any character in city matches with any character in valid cities
check_character_match <- function(city, valid_cities) {

  any(sapply(valid_cities, function(valid_city) {

    any(strsplit(city, NULL)[[1]] %in% strsplit(valid_city, NULL)[[1]])

  }))
}

#' Clean and correct city names
#'
#' @param df dataframe with the city column name
#' @param city_column_name name of the column wich has the city names
#' @param valid_cities C40 official City names
#' @param want_cityid TRUE/FALSE if you want to return a dataframe with a city_id column, in order to link it with the Data Warehouse. Default as FALSE
#' @param threshold matching level
#'
#' @return If clean_city_name = FALSE, returns just comparisson between the current city column names and the C40 official city names in the Data Warehouse.
#' If clean_city_name = TRUE, returns a dataframe with the correct and official city names
#' @export
check_and_correct_cities <- function(df, city_column_name, valid_cities, want_cityid = TRUE, threshold = 0.2) {

  df <- df %>%
    filter(sapply({{ city_column_name }}, check_character_match, valid_cities = valid_cities)) %>%
    mutate(
      # Clean the city names
      {{ city_column_name }} := str_remove_all({{ city_column_name }}, "District of |City of|City District Government|Distrito Capital|Ville de"),
      {{ city_column_name }} := str_remove_all({{ city_column_name }}, "Metropolitan Administration|City Administration|Metropolitan Municipality"),
      {{ city_column_name }} := str_remove_all({{ city_column_name }}, "Distrito Metropolitano de|Municipality|Government|Metropolitan Area"),
      {{ city_column_name }} := str_remove_all({{ city_column_name }}, "Prefeitura de|Prefeitura do|Region Metropolitana|The Local Government"),
      {{ city_column_name }} := str_remove_all({{ city_column_name }}, "Special Administrative Region|Greater|Authority|of|Región Metropolitana de"),
      {{ city_column_name }} := str_remove_all({{ city_column_name }}, "Metropolitan|The Local  of |of|Municipal People's|Special Administrative Region"),
      {{ city_column_name }} := str_remove_all({{ city_column_name }}, "The Local"),
      {{ city_column_name }} := str_trim({{ city_column_name }}),
      # Correct the city names
      corrected_city = sapply({{ city_column_name }}, find_closest_match, valid_cities = valid_cities, threshold = threshold),
      corrected_city = case_when(str_detect(corrected_city, "eThekwini") ~ "Durban (eThekwini)",
                                 .default = corrected_city)
    )

  if(want_cityid == TRUE){

    df <- df |>
      left_join(c40tools::get_c40cities(),
                by = c("corrected_city" = "city")) |>
      relocate(city_id, city)

    return(df)

  } else {
    return(df)
  }
}
