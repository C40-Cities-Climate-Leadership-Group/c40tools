#' C40 colour scale for filling
#'
#' A ggplot2 scale function that applies C40 colour palettes to fill aesthetics.
#'
#' @param palette Character. Palette name from \code{c40_pallets()}. Options are
#'   "qualitative", "sequential", "dicotomic", or "divergent".
#' @param discrete Logical. If \code{TRUE} (default), uses a discrete colour scale.
#'   If \code{FALSE}, uses a continuous gradient.
#' @param reverse Logical. If \code{TRUE}, reverses the palette order.
#'   Default is \code{FALSE}.
#' @param ... Additional arguments passed to \code{ggplot2::discrete_scale()} or
#'   \code{ggplot2::scale_fill_gradientn()}.
#'
#' @return A ggplot2 scale object.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(iris, aes(Species, Sepal.Width, fill = Species)) +
#'   geom_boxplot() +
#'   scale_fill_c40()
#' }
#'
#' @export
scale_fill_c40 <- function(palette = "qualitative", discrete = TRUE, reverse = FALSE, ...) {

  pal <- c40_pallets(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("fill", paste0("c40_", palette), palette = pal, ...)
  } else {
    ggplot2::scale_fill_gradientn(colors = pal(256), ...)
  }
}
