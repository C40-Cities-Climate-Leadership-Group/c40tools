# ==============================================================================
# Official C40 Colours - Updated September 2025
# Based on C40 Brand Guidelines September 2025
# See inst/brand/_brand.yml for full specification
# ==============================================================================

#                        Official C40 colours            ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Core palette with new colours (navy, forest) added April 2025
# Purple adjusted from #8d77c8 to #7E65C1 for accessibility
available_colors <- c(
  `yellow`  = "#FED939",
  `blue`    = "#23BCED",
  `navy`    = "#053D6B",
  `green`   = "#03C245",
  `forest`  = "#056608",
  `red`     = "#FF614A",
  `purple`  = "#7E65C1"
)

# Mid tints for backgrounds
available_colors_mid <- c(
 `yellow_mid`  = "#FEF1B8",
  `blue_mid`   = "#B0E7F8",
  `green_mid`  = "#A4E9BC",
  `red_mid`    = "#FFC6BE",
  `purple_mid` = "#D1C8E9"
)

# Light tints for subtle backgrounds
available_colors_light <- c(
  `yellow_light`  = "#FFFAE8",
  `blue_light`    = "#E5F7FC",
  `green_light`   = "#EBFAF0",
  `red_light`     = "#F5E8E0",
  `purple_light`  = "#F0EDF7"
)

#                      Official C40 palettes             ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Updated to match Brand Guidelines September 2025

available_pallets <- list(
  # For categorical data (up to 7 categories)
  `qualitative` = c("#FED939", "#23BCED", "#03C245", "#FF614A",
                    "#7E65C1", "#053D6B", "#056608"),

  # For ordered data (low to high) - blue sequence
  `sequential`  = c("#E5F7FC", "#B0E7F8", "#23BCED", "#053D6B"),

  # For binary data (dichotomous - kept spelling for backwards compatibility)
  `dicotomic`   = c("#FF614A", "#03C245"),

  # For data with meaningful midpoint
  `divergent`   = c("#FF614A", "#FFC6BE", "#FFFFFF", "#A4E9BC", "#03C245")
)

# Save internal data
usethis::use_data(
  available_colors,
  available_colors_mid,
  available_colors_light,
  available_pallets,
  overwrite = TRUE,
  internal = TRUE
)
