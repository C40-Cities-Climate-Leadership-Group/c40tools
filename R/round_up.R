#' Round Up Function (Vectorized)
#'
#' This function rounds a numeric value or vector up to a specified number of decimal places.
#'
#' @param x A numeric value or vector to be rounded.
#' @param decimal_places An integer specifying the number of decimal places to round up to. Default is 1.
#' @return A numeric value or vector rounded up to the specified number of decimal places.
#' @examples
#' round_up(c(1.35, -1.357, 2.363699), 2) # Returns c(1.4, -1.35, 2.37)
#' @export
round_up <- function(x, decimal_places = 1) {
  multiplier <- 10^decimal_places
  rounded_value <- ifelse(x >= 0,
                          ceiling(x * multiplier) / multiplier,
                          floor(x * multiplier) / multiplier)
  return(rounded_value)
}
