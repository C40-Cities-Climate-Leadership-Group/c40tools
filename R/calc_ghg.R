#' Obtain GHG inventory and modelled emissions
#'
#' @return
#' A dataset with the emissions figures
#' @export
#'
#' @examples
#' df_ghg_emissions <- calc_ghg(city = c("Oslo", "Copenhagen", "Stockholm"),
#'                                       year = 2000:2023,
#'                                       source = "both")
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                              Get GHG emissions                           ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
calc_ghg <- function(city = "all", year = 2000:2023, source = "both"){

  # Check the source reference
  assertthat::assert_that(source %in% c("both", "inventory", "modelled"),
                          msg = "Make sure that you are choosing one of these options: 'both', 'inventory', 'modelled'")

  # Extract all cities available
  all_cities <- c40tools::get_c40cities() |>
    dplyr::select(2) |>
    dplyr::pull()

  # Define year parameter
  var_year <- year


  if(any(city == "all")){

    var_cities <- all_cities

  } else {

    assertthat::assert_that(any(city %in% all_cities), msg = "The city spelling should coincide with the one in this list: c40tools::get_c40cities()")

    var_cities <- city

  }

  ### Create conection to the DW
  ### Check if connection is already established
  if(exists("con")){
    con <- con
  } else {
    con <- c40tools::get_dw_connection()
  }


  #........................Inventory figures.......................
  ### Get all inventories dataset from DW
  df_ghg_inventories_inventory <- dplyr::tbl(
    con,
    dbplyr::sql(
      glue::glue_sql(
        "
      WITH basic AS (SELECT city, inventory_year AS year, sum(emissions_tco2e) as emissions
                            FROM public.city_sectoral_emissions
                            WHERE source_inventory_basic = 'true'
                            GROUP BY city, year),
                basic_plus AS (SELECT city, inventory_year AS year, sum(emissions_tco2e) as emissions
                            FROM public.city_sectoral_emissions
                            WHERE source_inventory_basic_plus = 'true'
                            AND city IN ('Auckland','Austin','Dhaka','London','Madrid','Phoenix','Stockholm', 'Sydney')
                            GROUP BY city, year),
                curitiba AS (SELECT city, inventory_year AS year, (sum(emissions_tco2e)- 840615) as emissions
                            FROM public.city_sectoral_emissions
                            WHERE source_inventory_basic = 'true'
                            AND city = 'Curitiba'
                            GROUP BY city, year),
                hcmc AS (SELECT city, inventory_year AS year, (sum(emissions_tco2e)-8953225) as emissions
                            FROM public.city_sectoral_emissions
                            WHERE source_inventory_basic = 'true'
                            AND city = 'Ho Chi Minh City'
                            GROUP BY city, year),
                rio AS (SELECT city, inventory_year AS year, (sum(emissions_tco2e)- 3653032 ) as emissions
                            FROM public.city_sectoral_emissions
                            WHERE source_inventory_basic = 'true'
                            AND city = 'Rio de Janeiro'
                            GROUP BY city, year),
                sao_paulo AS (WITH basic as (SELECT city, inventory_year AS year, sum(emissions_tco2e) as basic_emissions
                                            FROM public.city_sectoral_emissions
                                            WHERE source_inventory_basic = 'true'
                                            AND city = 'São Paulo'
                                            GROUP BY city, year),
                                sector as ((SELECT city, inventory_year AS year, coalesce (emissions_tco2e,0) AS emissions_sector
                                            FROM public.city_sectoral_emissions where source_code = 'ii.2.1' and city = 'São Paulo'))
                            SELECT city, year, (basic_emissions - emissions_sector) as emissions
                            FROM basic
                            LEFT JOIN sector using (city, year)),
                lima AS (WITH basic as (SELECT city, inventory_year AS year, sum(emissions_tco2e) as basic_emissions
                                            FROM public.city_sectoral_emissions
                                            WHERE source_inventory_basic = 'true'
                                            AND city = 'Lima'
                                            GROUP BY city, year),
                                sector as ((SELECT city, inventory_year AS year, coalesce (emissions_tco2e,0) AS emissions_sector
                                            FROM public.city_sectoral_emissions where source_code = 'iv.1.1' and city = 'Lima'))
                            SELECT city, year, (basic_emissions + emissions_sector) as emissions
                            FROM basic
                            LEFT JOIN sector using (city, year)),
                quito AS (WITH basic as (SELECT city, inventory_year AS year, sum(emissions_tco2e) as basic_emissions
                                            FROM public.city_sectoral_emissions
                                            WHERE source_inventory_basic = 'true'
                                            AND city = 'Quito'
                                            GROUP BY city, year),
                                sector as ((SELECT city, inventory_year AS year, coalesce (sum(emissions_tco2e),0) AS emissions_sector
                                            FROM public.city_sectoral_emissions where source_sector = 'AFOLU' and city = 'Quito'
                                            GROUP BY city, year))
                            SELECT city, year, (basic_emissions + emissions_sector) as emissions
                            FROM basic
                            LEFT JOIN sector using (city, year))

             SELECT t1.city, t1.year,
                     COALESCE(t2.emissions, t3.emissions, t4.emissions, t5.emissions, t6.emissions, t7.emissions, t8.emissions, t1.emissions) AS emissions_tco2e_inventory
            FROM basic t1
            LEFT JOIN basic_plus t2 USING (city, year)
            LEFT JOIN curitiba t3 USING (city, year)
            LEFT JOIN hcmc t4 USING (city, year)
            LEFT JOIN rio t5 USING (city, year)
            LEFT JOIN sao_paulo t6 USING (city, year)
            LEFT JOIN lima t7 USING (city, year)
            LEFT JOIN quito t8 USING (city, year)
            WHERE year IN ({vals*})
      ",
        vals = var_year)
    )
  ) |>
    # mutate(use_in_dashboard_hierarchy = case_when(use_in_dashboard == "true" ~ 1,
    #                                               use_in_dashboard == "not sharable" ~ 2,
    #                                               use_in_dashboard == "false" ~ 3)) |>
    # group_by(city, inventory_year) |>
    # slice_min(use_in_dashboard_hierarchy) |>
    # slice_max(created_at) |>
    # filter(use_in_dashboard %in% c("true", "not sharable")) |>
    # filter(city %in% var_cities) |>
    # select(city_id, city, country, year = inventory_year, emissions_tco2e_inventory = emissions_tco2e) |>
    dplyr::collect()


  #........................Modelled figures........................
  if(source %in% c("both", "modelled")){

    df_ghg_inventories_modelled <- dplyr::tbl(
      con,
      dbplyr::sql(
        glue::glue_sql(
          "
      SELECT t2.city_id, t2.city, t2.country, year, emissions_tco2e as emissions_tco2e_modelled
      FROM public.fact_city_modelled_emissions t1
      LEFT JOIN public.dim_cities t2
      USING (city_id)
      WHERE t1.created_at = (SELECT MAX(created_at) FROM public.fact_city_modelled_emissions)
      and year IN ({vals*})
      ",
          vals = var_year)
      )
    ) |>
      dplyr::filter(city %in% var_cities) |>
      dplyr::collect()
  }


  if(source == "inventory"){

    df_output <- df_ghg_inventories_inventory |>
      dplyr::arrange(city, year)

  }

  if(source == "modelled"){

    df_output <- df_ghg_inventories_modelled |>
      dplyr::arrange(city, year)

  }

  if(source == "both"){

    df_output <- df_ghg_inventories_inventory |>
      dplyr::right_join(df_ghg_inventories_modelled) |>
      dplyr::select(city, country, year, emissions_tco2e_inventory, emissions_tco2e_modelled) |>
      dplyr::arrange(city, year)

  }

  return(df_output)
}

