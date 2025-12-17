#' C40 Colour Scale for Colour Aesthetics
#'
#' A ggplot2 scale function that applies C40 colour palettes to colour aesthetics
#' (borders, lines, points).
#'
#' @param palette Character. Palette name from \code{\link{c40_palettes}()}.
#'   Options are "qualitative", "sequential", "dicotomic", or "divergent".
#' @param discrete Logical. If \code{TRUE} (default), uses a discrete colour scale.
#'   If \code{FALSE}, uses a continuous gradient.
#' @param reverse Logical. If \code{TRUE}, reverses the palette order.
#'   Default is \code{FALSE}.
#' @param ... Additional arguments passed to \code{ggplot2::discrete_scale()} or
#'   \code{ggplot2::scale_color_gradientn()}.
#'
#' @return A ggplot2 scale object.
#'
#' @seealso \code{\link{scale_fill_c40}}, \code{\link{c40_palettes}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Width, Sepal.Length, colour = Species)) +
#'   geom_point(size = 4) +
#'   scale_color_c40()
#' }
scale_color_c40 <- function(palette = "qualitative", discrete = TRUE, reverse = FALSE, ...) {

  pal <- c40_palettes(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale(
      aesthetics = "colour",
      palette = pal,
      ...
    )
  } else {
    ggplot2::scale_color_gradientn(colours = pal(256), ...)
  }
}
