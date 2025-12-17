#' Calculate Greenhouse Gas (GHG) Emissions by Region, Tier, or City
#'
#' This function calculates and summarizes greenhouse gas (GHG) emissions for specified regions,
#' capacity tiers, or cities based on modeled and target emissions data from the C40 Data Warehouse.
#' It retrieves data from the database, performs necessary data processing, and outputs emissions
#' per capita and other related metrics based on the chosen grouping.
#'
#' @param region A character string specifying the region to filter by. Valid options include:
#'   \code{"all"}, \code{"Africa"}, \code{"Central East Asia"}, \code{"East, Southeast Asia and Oceania"},
#'   \code{"Europe"}, \code{"Latin America"}, \code{"North America"}, and \code{"South and West Asia"}.
#'   The default is \code{"all"}, which includes all regions.
#' @param sum_by A character string specifying the grouping for the summary. Options include:
#'   \code{"region"}, \code{"tier"}, or \code{"city"}. \code{"region"} groups results by year and region,
#'   \code{"tier"} groups by year, tier, and tier description, and \code{"city"} groups by year, region, and city.
#'
#' @return A data frame containing the following columns:
#' \itemize{
#'   \item \code{year}: The year of the emissions data.
#'   \item \code{region}: The region of the emissions data (if applicable).
#'   \item \code{city}: The city (if \code{sum_by = "city"} is used).
#'   \item \code{population}: The total population for the grouping.
#'   \item \code{target_emissions_tco2e}: The target emissions in tonnes of CO2 equivalent.
#'   \item \code{actual_emissions_tco2e}: The actual emissions in tonnes of CO2 equivalent.
#'   \item \code{percapita_actual}: Actual emissions per capita.
#'   \item \code{percapita_target}: Target emissions per capita.
#'   \item \code{gap_percapita}: The percentage gap between actual and target per capita emissions.
#'   \item \code{gap_absolute}: The percentage gap between actual and target absolute emissions.
#'   \item \code{gap_percapita_color}: A color-coded classification of the \code{gap_percapita}.
#' }
#'
#' @details The function establishes a connection to the C40 Data Warehouse and retrieves
#' emissions data from multiple database tables. The data is then filtered by the specified
#' \code{region} and joined with existing tier data in the package. The grouping and summarization
#' depend on the \code{sum_by} parameter, and the final output includes calculated metrics to
#' help evaluate emission targets.
#'
#' @examples
#' \dontrun{
#' # Calculate emissions for all regions, grouped by region
#' calc_ghg_emissions(region = "all", sum_by = "region")
#'
#' # Calculate emissions for Europe, grouped by tier
#' calc_ghg_emissions(region = "Europe", sum_by = "tier")
#'
#' # Calculate emissions for North America, grouped by city
#' calc_ghg_emissions(region = "North America", sum_by = "city")
#' }
#'
#' @export
calc_ghg_emissions <- function(region = "all", sum_by = "city") {

  ## Checks
  assertthat::assert_that(
    region %in% c("all", "Africa", "Central East Asia",
                  "East, Southeast Asia and Oceania", "Europe",
                  "Latin America", "North America", "South and West Asia"),
    msg = "region values must be one of these: 'all', 'Africa', 'Central East Asia', 'East, Southeast Asia and Oceania', 'Europe', 'Latin America', 'North America' or 'South and West Asia'"
  )
  assertthat::assert_that(
    sum_by %in% c("region", "tier", "city"),
    msg = "sum_by values must be one of these: 'region', 'tier', or 'city'"
  )

  filter_region <- region
  filter_by <- sum_by

  # Establish database connection
  con <- get_dw_connection()

  ### Get emissions from inventories only by year and city
  df_city_inventory_emissions <- dplyr::tbl(con,
                                            DBI::Id(schema = "public",
                                                    table  = "city_total_emissions_serie")) |>
    dplyr::collect()


  # SQL query for extracting modelled emissions
  targets_query <- "
    WITH cities AS (
      SELECT city, city_id, region
      FROM dim_cities
      WHERE current_member = true
    ),
    years AS (
      SELECT year
      FROM generate_series(2015, 2050) AS year
      WHERE year IN (
          2015, 2016, 2017, 2018, 2019, 2020,
          2021, 2022, 2023, 2024, 2025, 2030, 2050
      )
    ),
    modelled_emissions AS (
      SELECT city_id, year, emissions_tco2e, created_at
      FROM fact_city_modelled_emissions
      WHERE year <= EXTRACT(YEAR FROM CURRENT_DATE)::integer
        AND created_at = (
            SELECT MAX(created_at)
            FROM fact_city_modelled_emissions
        )
    ),
    d2020_targets_union AS (
      SELECT city_id, year, emissions_tco2e AS target_emissions_tco2e, 1 AS source_priority
      FROM public.fact_city_d2020_trajectories
      WHERE created_at = (
          SELECT MAX(created_at)
          FROM public.fact_city_d2020_trajectories
      )
      UNION ALL
      SELECT t1.city_id, t1.year,
        ROUND((t1.emissions_percentage / 100.0 * t2.baseline_emissions_tco2e)::numeric, 0) AS target_emissions_tco2e,
        2 AS source_priority
      FROM modelling.d2020_emission_targets t1
      LEFT JOIN (
          SELECT city_id, emissions_tco2e AS baseline_emissions_tco2e
          FROM modelled_emissions
          WHERE year = 2015
      ) t2 ON t1.city_id = t2.city_id
    ),
    d2020_targets AS (
      SELECT city_id, year, target_emissions_tco2e
      FROM (
          SELECT *, ROW_NUMBER() OVER (PARTITION BY city_id, year ORDER BY source_priority) AS rn
          FROM d2020_targets_union
      ) sub
      WHERE rn = 1
    ),
    cap_targets AS (
      SELECT dc.city_id, ces.year, ces.emissions_tco2e AS target_emissions_tco2e
      FROM city_emission_scenarios ces
      LEFT JOIN dim_cities dc ON ces.city = dc.city
      WHERE ces.scenario = 'ambitious scenario'
    )
    SELECT t.city, t.city_id, t.region, t.year,
           t.emissions_tco2e AS actual_emissions_tco2e,
           ROUND((t.emissions_tco2e / t.population)::numeric, 6) AS actual_emissions_per_capita_tco2e,
           t.target_emissions_tco2e,
           ROUND((t.target_emissions_tco2e / t.population)::numeric, 6) AS target_emissions_per_capita_tco2e,
           population, dac_category
    FROM (
        SELECT t1.city, t1.city_id, t1.region, t1.year, population,
               t3.emissions_tco2e,
               COALESCE(t4.target_emissions_tco2e, t5.target_emissions_tco2e) AS target_emissions_tco2e,
               dac_category
        FROM (
            SELECT c.city, c.city_id, c.region, y.year
            FROM cities c CROSS JOIN years y
        ) t1
        LEFT JOIN dim_city_parameters t2 ON t1.city_id = t2.city_id AND t1.year = t2.year
        LEFT JOIN modelled_emissions t3 ON t1.city_id = t3.city_id AND t1.year = t3.year
        LEFT JOIN cap_targets t4 ON t1.city_id = t4.city_id AND t1.year = t4.year
        LEFT JOIN d2020_targets t5 ON t1.city_id = t5.city_id AND t1.year = t5.year
        LEFT JOIN dim_city_typologies AS t6 ON t1.city_id = t6.city_id
    ) t
    ORDER BY t.city, t.year"



  # Run query and retrieve data
  df_targets <- dplyr::tbl(con, dbplyr::sql(targets_query)) |>
    dplyr::mutate(
      dac_category = dplyr::case_when(
        city %in% c("Dhaka South", "Dhaka North", "Ahmedabad", "Fortaleza") ~ "global south",
        TRUE ~ dac_category
      )
    ) |>
    dplyr::filter(if (filter_region != "all") region == filter_region else TRUE) |>
    dplyr::collect()

  # Close the connection
  DBI::dbDisconnect(con)

  # Use `df_tiers` from the package's data
  df_viz <- df_targets |>
    dplyr::left_join(c40tools::df_tiers, by = "city")

  # Grouping and summarizing based on `sum_by`
  grouping_vars <- if (sum_by == "region") {
    c("year", "region")
    } else if (sum_by == "tier") {
      c("year", "tier", "tier_description")
      } else if (sum_by == "city") {
        c("year", "region", "city")
      }

  df_viz <- df_viz |>
    dplyr::filter(!is.na(actual_emissions_tco2e)) |>
    dplyr::group_by(dplyr::across(dplyr::all_of(grouping_vars))) |>
    dplyr::summarise(
      population = sum(population, na.rm = TRUE),
      target_emissions_tco2e = sum(target_emissions_tco2e, na.rm = TRUE),
      actual_emissions_tco2e = sum(actual_emissions_tco2e, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      percapita_actual = actual_emissions_tco2e / population,
      percapita_target = target_emissions_tco2e / population,
      gap_percapita = (percapita_actual - percapita_target) / percapita_target * 100,
      gap_absolute = (actual_emissions_tco2e - target_emissions_tco2e) / target_emissions_tco2e * 100,
      gap_percapita_color = dplyr::case_when(
        gap_percapita <= 10 ~ c40_colors("green"),
        gap_percapita > 10 & gap_percapita <= 20 ~ c40_colors("yellow"),
        TRUE ~ c40_colors("red")))


  if (sum_by == "city") {
    df_viz <- df_viz |>
      dplyr::left_join(df_city_inventory_emissions, by = c("city", "year"))
    } else {
      df_viz
    }

  return(df_viz)
}
