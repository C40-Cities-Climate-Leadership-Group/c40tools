#' Establish a Connection to the C40 Data Warehouse
#'
#' This function establishes a connection to the C40 Data Warehouse using environment variables
#' for the database host, user, and password. The connection is established through the
#' `RPostgres` package.
#'
#' @return A `DBI` connection object to the C40 Data Warehouse.
#'
#' @details
#' The function requires the following environment variables to be defined in your `.Renviron` file:
#' * `DATAWAREHOUSE_HOST`: Hostname of the Data Warehouse.
#' * `DATAWAREHOUSE_USER`: Username for Data Warehouse authentication.
#' * `DATAWAREHOUSE_PASSWORD`: Password for Data Warehouse authentication.
#'
#' If any of these environment variables are missing, the function will raise an error.
#'
#' @examples
#' # Establish a connection to the data warehouse
#' con <- get_dw_connection()
#'
#' # Example query to fetch data
#' df_targets <- dplyr::tbl(con,
#'                   dbplyr::sql("
#'                        SELECT * FROM public.fact_city_emission_targets
#'                        ")) |>
#'               dplyr::collect()
#'
#' @export
get_dw_connection <- function() {

  # Check that you have the proper keys defined on the .Renviron file
  assertthat::assert_that(nchar(Sys.getenv("DATAWAREHOUSE_HOST")) != 0,
                          msg = "You need to set DATAWAREHOUSE_HOST key on your .Renviron file")

  assertthat::assert_that(nchar(Sys.getenv("DATAWAREHOUSE_USER")) != 0,
                          msg = "You need to set DATAWAREHOUSE_USER key on your .Renviron file")

  assertthat::assert_that(nchar(Sys.getenv("DATAWAREHOUSE_PASSWORD")) != 0,
                          msg = "You need to set DATAWAREHOUSE_PASSWORD key on your .Renviron file")


  # Open connection to the Data Warehouse
  con <- DBI::dbConnect(RPostgres::Redshift(),
                        host = Sys.getenv("DATAWAREHOUSE_HOST"),
                        dbname = "postgres",
                        user = Sys.getenv("DATAWAREHOUSE_USER"),
                        password = Sys.getenv("DATAWAREHOUSE_PASSWORD"),
                        port = 5432)

  return(con)
}
