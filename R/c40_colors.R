
#' Function to get C40 colors
#'
#' @param ... Name or number of the color. The available c40 colors can be viewed with `avalilable_colors()`.
#' @param name If TRUE returns the name of the hex color
#' @return
#' C40 color pallets
#' @export
#'
#' @examples
#' ### Get c40 yellow color
#' c40_colors("yellow", name = TRUE)
#'
#' c40_colors("yellow", name = FALSE)

c40_colors <- function(..., name = FALSE) {

  cols <- c(...)

  if (is.null(cols)) {
    if(name == FALSE){
      return(unname(available_colors))
    } else {
      return(available_colors)
    }
  }

  if (!is.null(cols) & is.character(cols)) {
    assertthat::assert_that(cols %in% c(names(available_colors)),
                            msg = glue::glue("The value must be one of the nex ones: {paste0(names(available_colors), collapse = ', ')}"))

    if(name == FALSE){
      return(unname(available_colors[cols]))
    } else {
      return(available_colors[cols])
    }
  }

  if (!is.null(cols) & is.numeric(cols)){

    assertthat::assert_that(unique(cols) %in% c(1:10),
                            msg = glue::glue("The numeric values goes from 1 to {length(available_colors)}"))

    if(name == FALSE){
      return(unname(available_colors[cols]))
    } else {
      return(available_colors[cols])
    }

    return(unname(available_colors[cols]))
  }
}

