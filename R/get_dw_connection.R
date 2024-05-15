#' Get connected to the C40 Data Warehouse
#'
#' @return a RPostgres connection
#' @export
#'
#' @examples
#' con <- get_dw_connection()
#'
#' df_targets <- dplyr::tbl(con,
#'                   dbplyr::sql("
#'                        SELECT * FROM public.fact_city_emission_targets
#'                        "))
get_dw_connection <- function() {

  # Check that you have the proper keys defined on the .Renviron file
  assertthat::assert_that(nchar(Sys.getenv("DATAWAREHOUSE_HOST")) != 0,
                          msg = "You need to set DATAWAREHOUSE_HOST key on your .Renviron file")

  assertthat::assert_that(nchar(Sys.getenv("DATAWAREHOUSE_USER")) != 0,
                          msg = "You need to set DATAWAREHOUSE_USER key on your .Renviron file")

  assertthat::assert_that(nchar(Sys.getenv("DATAWAREHOUSE_PASSWORD")) != 0,
                          msg = "You need to set DATAWAREHOUSE_PASSWORD key on your .Renviron file")


  # Open conection to the Data Warehouse
  con <- DBI::dbConnect(RPostgres::Redshift(),
                        host = Sys.getenv("DATAWAREHOUSE_HOST"),
                        dbname = "postgres",
                        user = Sys.getenv("DATAWAREHOUSE_USER"),
                        password = Sys.getenv("DATAWAREHOUSE_PASSWORD"),
                        port = 5432)

  return(con)
}
