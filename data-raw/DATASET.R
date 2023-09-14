
#                        Official C40 colors             ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
available_colors <- c(
  `green`    = "#03c245",
  `blue`     = "#23BCED",
  `yellow`  = "#fed939",
  `violet`   = "#8d77c8",
  `red`      = "#ff614a",
  `dark_red` = "#d4444d"
)



#                      Official c40 pallets              ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

available_pallets <- list(

  `qualitative` = c("#03c245", "#23BCED", "#ff614a", "#8d77c8", "#fed939"),
  `sequential`  = c("#03c245", "#23BCED","#8d77c8", "#fed939"),
  `dicotomic`  = c("#23BCED", "#03c245"),
  `divergent`  = c("#ff614a", "#AAAAAA", "#03c245"))

usethis::use_data(available_colors, available_pallets, overwrite = TRUE, internal = TRUE)
