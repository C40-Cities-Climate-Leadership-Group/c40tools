#' Get current and past C40 cities
#'
#' @param year TRUE as default, brings only current C40 cities. FALSE brings all C40 cities hosted in the Data Warehouse
#' @return
#' A dataset with the City, City id and if it is currently part of C40
#' @export
#'
#' @examples
#' df_c40_cities <- get_c40cities(current = TRUE)
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                             current c40 cities                           ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_c40cities <- function(current = TRUE){

  ### Check if connection is already established
  if(exists("con")){
    con <- con
  } else {
    con <- c40tools::get_dw_connection()
  }

  ### Get the data
  if(current){
    df_c40_cities <- dplyr::tbl(
      con,
      dbplyr::sql(
        "SELECT city_id, city, current_member
    FROM dim_cities
    WHERE current_member = 'true'
    ORDER BY city ASC
    "
      )
    ) |>
      dplyr::collect()
  } else {
    df_c40_cities <- dplyr::tbl(
      con,
      dbplyr::sql(
        "SELECT city_id, city, current_member
            FROM dim_cities
            ORDER BY city ASC
            "
      )
    ) |>
      dplyr::collect()
  }

  return(df_c40_cities)

}
