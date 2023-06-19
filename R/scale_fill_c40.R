#' C40 Scale color for filling
#'
#' @param palette pallet name from `c40_pallets()`. Options can be viewed in `available_pallet()`
#' @param discrete *TRUE* for discrete variables
#' @param reverse *TRUE* returns inverted colors
#' @param ... Aditional arguments for discrete_scale() or
#'            scale_color_gradientn()
#' @examples
#'
#' @export

### Funcion
scale_fill_c40 <- function(palette = "qualitative", discrete = TRUE, reverse = FALSE, ...) {

  pal <- c40_pallets(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("fill", paste0("c40_", palette), palette = pal, ...)
  } else {
    ggplot2::scale_fill_gradientn(colors = pal(256), ...)
  }
}

