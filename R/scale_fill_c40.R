#' C40 Colour Scale for Fill Aesthetics
#'
#' A ggplot2 scale function that applies C40 colour palettes to fill aesthetics.
#'
#' @param palette Character. Palette name from \code{\link{c40_palettes}()}.
#'   Options are "qualitative", "sequential", "dicotomic", or "divergent".
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
#' @seealso \code{\link{scale_color_c40}}, \code{\link{c40_palettes}}
#'
#' @export
scale_fill_c40 <- function(palette = "qualitative", discrete = TRUE, reverse = FALSE, ...) {

  pal <- c40_palettes(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale(
      aesthetics = "fill",
      palette = pal,
      ...
    )
  } else {
    ggplot2::scale_fill_gradientn(colours = pal(256), ...)
  }
}
