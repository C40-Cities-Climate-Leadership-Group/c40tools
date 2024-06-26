% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_dw_connection.R
\name{get_dw_connection}
\alias{get_dw_connection}
\title{Get connected to the C40 Data Warehouse}
\usage{
get_dw_connection()
}
\value{
a RPostgres connection
}
\description{
Get connected to the C40 Data Warehouse
}
\examples{
con <- get_dw_connection()

df_targets <- dplyr::tbl(con,
                  dbplyr::sql("
                       SELECT * FROM public.fact_city_emission_targets
                       "))
}
