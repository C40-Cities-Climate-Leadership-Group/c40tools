#' C40 border color scale
#'
#' @param palette Pallet name from `c40_pallets()`
#' @param discrete *TRUE* for discrete variables
#' @param reverse *TRUE* returns inverted colors
#' @param ... Aditional arguments for discrete_scale() or
#'            scale_color_gradientn()
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
#' geom_point(size = 4) +
#' scale_color_c40()


scale_color_c40 <- function(palette = "qualitative", discrete = TRUE, reverse = FALSE, ...) {

  pal <- c40_pallets(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("color", paste0("c40_", palette), palette = pal, ...)
  } else {
    ggplot2::scale_color_gradientn(colors = pal(256), ...)
  }
}
