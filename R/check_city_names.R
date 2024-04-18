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
#'
check_city_names <- function(df, city_var_name, clean_city_name = FALSE, want_cityid = FALSE){

  con <- c40tools::get_dw_connection()

  df_cities <- dplyr::tbl(con,
                          DBI::Id(schema = "public",
                                  table = "dim_cities")) |>
    dplyr::filter(current_member == TRUE) |>
    dplyr::select(city, city_id) |>
    dplyr::collect()


  if(clean_city_name == FALSE){
    # Set the city columna name as city
    colnames(df[city_var_name]) <- "city"

    df_1 <- sort(unique(df_cities$city))

    df_2 <- sort(unique(df_aq_mortality$city))

    waldo::compare(df_1, df_2, quote_strings = FALSE)
  }

  if(clean_city_name == TRUE){

    df <- df |>
      mutate(city_stage1 = tolower(c40tools::clean_text(city)),
             new_city_name = case_when(city_stage1 == "ciudad de mexico" ~ "Mexico City",
                                       city_stage1 == "pretoria" ~ "Tshwane",
                                       city_stage1 == "hong kong, china" ~ "Hong Kong",
                                       city_stage1 == "tel aviv" ~ "Tel Aviv-Yafo",
                                       city_stage1 == "metropolitan municipality of lima" ~ "Lima",
                                       city_stage1 == "municipio de lisboa" ~ "Lisbon",
                                       .default = city)) |>
      select(-city, -city_stage1) |>
      relocate(city = new_city_name)

  }

  if(want_cityid == FALSE){

    return(df)

  } else {

    df <- df |>
      left_join(df_cities) |>
      relocate(city_id)

    return(df)
  }
}
