#' Get current and past C40 cities
#'
#' Retrieves the list of C40 member cities from the Data Warehouse.
#'
#' @param current Logical. If \code{TRUE} (default), returns only current C40
#'   member cities. If \code{FALSE}, returns all cities including past members.
#'
#' @return A data frame with the following columns:
#' \describe{
#'   \item{city_id}{Integer. Unique identifier for the city in the Data Warehouse}
#'   \item{city}{Character. Official name of the city}
#'   \item{current_member}{Logical. Whether the city is currently a C40 member}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get current C40 member cities
#' df_c40_cities <- get_c40cities(current = TRUE)
#'
#' # Get all cities (including past members)
#' df_all_cities <- get_c40cities(current = FALSE)
#' }
get_c40cities <- function(current = TRUE) {

 con <- get_dw_connection()
 on.exit(DBI::dbDisconnect(con), add = TRUE)

 if (current) {
 query <- "SELECT city_id, city, current_member
              FROM dim_cities
              WHERE current_member = 'true'
              ORDER BY city ASC"
 } else {
 query <- "SELECT city_id, city, current_member
              FROM dim_cities
              ORDER BY city ASC"
 }

 df_c40_cities <- dplyr::tbl(con, dbplyr::sql(query)) |>
 dplyr::collect()

 return(df_c40_cities)
}
