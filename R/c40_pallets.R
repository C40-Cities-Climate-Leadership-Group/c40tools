#' Get C40 Colour Palettes
#'
#' Returns a colour palette function based on C40 brand guidelines.
#' The returned function can be used to generate any number of colours
#' by interpolation.
#'
#' @param palette Character. Name of the colour palette. Options are:
#'   \describe{
#'     \item{"qualitative"}{For categorical data (7 distinct colours)}
#'     \item{"sequential"}{For ordered data (light to dark blue)}
#'     \item{"dicotomic"}{For binary data (red/green) - note: kept for
#'       backwards compatibility, preferred spelling is "dichotomous"}
#'     \item{"divergent"}{For data with meaningful midpoint (red-white-green)}
#'   }
#' @param reverse Logical. If \code{TRUE}, reverses the palette order.
#'   Default is \code{FALSE}.
#' @param ... Additional arguments passed to \code{grDevices::colorRampPalette()}.
#'
#' @return A function that takes an integer \code{n} and returns \code{n} colours.
#'
#' @examples
#' # Get qualitative palette function
#' pal <- c40_palettes("qualitative")
#' pal(5)  # Generate 5 colours
#'
#' # Use with ggplot2
#' \dontrun{
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Width, Sepal.Length, colour = Species)) +
#'   geom_point() +
#'   scale_colour_manual(values = c40_palettes("qualitative")(3))
#' }
#'
#' @seealso \code{\link{scale_fill_c40}}, \code{\link{scale_color_c40}},
#'   \code{\link{c40_colours}}
#'
#' @export
c40_palettes <- function(palette = "qualitative", reverse = FALSE, ...) {
  pal <- available_pallets[[palette]]

 if (is.null(pal)) {
    available <- paste(names(available_pallets), collapse = ", ")
    stop(
      sprintf("Palette '%s' not found. ", palette),
      sprintf("Available palettes: %s", available),
      call. = FALSE
    )
  }

  if (reverse) pal <- rev(pal)

  grDevices::colorRampPalette(pal, ...)
}


#' Get C40 Colour Palettes (Deprecated)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' \code{c40_pallets()} has been renamed to \code{\link{c40_palettes}()} for
#' correct spelling. Please update your code to use \code{c40_palettes()}.
#'
#' @inheritParams c40_palettes
#'
#' @return A function that takes an integer \code{n} and returns \code{n} colours.
#'
#' @seealso \code{\link{c40_palettes}}
#'
#' @export
#' @keywords internal
c40_pallets <- function(palette = "qualitative", reverse = FALSE, ...) {
  warning(
    "c40_pallets() is deprecated. Please use c40_palettes() instead.",
    call. = FALSE
  )
  c40_palettes(palette = palette, reverse = reverse, ...)
}
