# Tests for calc_ghg_emissions function
# Note: These tests check argument validation without requiring DB connection

test_that("calc_ghg_emissions validates region argument", {
 expect_error(
   calc_ghg_emissions(region = "Invalid Region"),
   regexp = "region values must be one of"
 )

 expect_error(
   calc_ghg_emissions(region = "antarctica"),
   regexp = "region values must be one of"
 )
})

test_that("calc_ghg_emissions validates sum_by argument", {
 expect_error(
   calc_ghg_emissions(sum_by = "invalid"),
   regexp = "sum_by values must be one of"
 )

 expect_error(
   calc_ghg_emissions(sum_by = "country"),
   regexp = "sum_by values must be one of"
 )
})

# Skip tests that require DB connection
test_that("calc_ghg_emissions fails gracefully without DB credentials", {
 skip_if(
   nchar(Sys.getenv("DATAWAREHOUSE_HOST")) > 0,
   "Skipping: DB credentials are set"
 )

 # Without credentials, should fail on DATAWAREHOUSE_HOST check
 expect_error(
   calc_ghg_emissions(),
   regexp = "DATAWAREHOUSE"
 )
})
