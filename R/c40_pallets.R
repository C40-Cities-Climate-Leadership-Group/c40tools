#' Get the C40 color pallets
#'
#' @param palette Name of the color pallet. The available color pallets can be viewed with `available_pallets()`
#' @param reverse if *TRUE* returns inverted color pallet
#' @param ... Aditional arguments to define with colorRampPalette()
#' @return
#' C40 official color pallets
#' @export

c40_pallets <- function(palette = "qualitative", reverse = FALSE, ...) {

  pal <- available_pallets[[palette]]

  if (reverse) pal <- rev(pal)

  grDevices::colorRampPalette(pal, ...)
}
