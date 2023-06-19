#' Code examples for accesing the data from the Data Warehouse
#'
#' @param type Type of request (sql script, table)
#'
#' @return a text with the code to see how the Data Warehouse can be accessed
#' @export
#'
#' @examples
#' get_dw_db_example(type = 'sql')
get_dw_db_example <- function(type = 'table'){

  assertthat::assert_that(type %in% c("sql", 'table'))

  if(type == "sql"){

    cat("This is an example of how to download a table from the dw via an sql request \n\n")

    Sys.sleep(2)
    cat('df <- tbl(con,
                                 sql("
                       SELECT * FROM dim_cities
                       LEFT JOIN fact_city_modelled_emissions
                       ON dim_cities.city_id = fact_city_modelled_emissions.city_id
                       ")) |>
            collect())')
  }


  if(type == "table"){

    cat("This is an example of how to download a table from the dw \n\n")

    Sys.sleep(2)
    cat('df <- tbl(con,
                         Id(schema = "public",
                            table = "fact_city_modelled_emissions")) |>
    collect()')
  }



}
