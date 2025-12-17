# Global variable declarations for NSE (Non-Standard Evaluation)
#
# These declarations prevent R CMD check NOTEs about "no visible binding
# for global variable" when using dplyr and other tidyverse packages.

utils::globalVariables(c(
 # Column names used in dplyr operations
 "actual_emissions_tco2e",
 "city",
 "city_id",
 "city_stage1",
 "corrected_city",
 "current_member",
 "new_city_name",
 "percapita_actual",
 "percapita_target",
 "population",
 "target_emissions_tco2e",
 # Operator
 ":="
))
