#' Access C40 Brand Configuration
#'
#' Reads and returns the C40 brand configuration from the package's
#' `_brand.yml` file. This configuration follows the Quarto brand.yml
#' specification and can be used for Shiny applications, Quarto documents,
#' and ggplot2 visualisations.
#'
#' @param section Character. Optional section to extract from the brand
#'   configuration. If \code{NULL} (default), returns the full configuration.
#'   Valid sections include: "color", "typography", "logo", "design", "shiny",
#'   "quarto", "ggplot2", "accessibility".
#' @param simplify Logical. If \code{TRUE} and a section is specified, attempts
#'   to simplify the output to a named vector where applicable. Default is
#'   \code{FALSE}.
#'
#' @return A list containing the brand configuration, or a subset if a section
#'   is specified.
#'
#' @examples
#' \dontrun{
#' # Get full brand configuration
#' brand <- c40_brand()
#'
#' # Get colour palette
#' colours <- c40_brand("color")
#'
#' # Get typography settings
#' fonts <- c40_brand("typography")
#'
#' # Get ggplot2 defaults
#' ggplot_settings <- c40_brand("ggplot2")
#' }
#'
#' @export
c40_brand <- function(section = NULL, simplify = FALSE) {
  brand_file <- system.file("brand", "_brand.yml", package = "c40tools")


if (brand_file == "") {
    stop(
      "Brand configuration file not found. ",
      "Please ensure the c40tools package is properly installed.",
      call. = FALSE
    )
  }

  brand <- yaml::yaml.load_file(brand_file)

  if (is.null(section)) {
    return(brand)
  }

  if (!section %in% names(brand)) {
    available <- paste(names(brand), collapse = ", ")
    stop(
      sprintf("Section '%s' not found in brand configuration. ", section),
      sprintf("Available sections: %s", available),
      call. = FALSE
    )
  }

  result <- brand[[section]]

  if (simplify && is.list(result)) {
    # Attempt to simplify nested colour values
    result <- tryCatch(
      unlist(result, recursive = FALSE),
      error = function(e) result
    )
  }

  result
}


#' Get C40 Brand Colours
#'
#' Convenience function to retrieve C40 brand colours. Returns colours
#' as hex values that can be used directly in R graphics and ggplot2.
#'
#' @param palette Character. The colour palette to retrieve. Options are:
#'   \describe{
#'     \item{"core"}{Core brand colours (7 colours)}
#'     \item{"qualitative"}{For categorical data (7 colours)}
#'     \item{"sequential"}{For ordered data - returns blue sequence by default}
#'     \item{"divergent"}{For data with meaningful midpoint (5 colours)}
#'     \item{"dichotomous"}{For binary data (2 colours)}
#'     \item{"all"}{Returns all colour definitions}
#'   }
#' @param tint Character. For palettes with tints, specify "core", "mid", or
#'   "light". Default is "core".
#' @param names Logical. If \code{TRUE}, returns a named vector with colour
#'   names. Default is \code{TRUE}.
#'
#' @return A character vector of hex colour codes.
#'
#' @examples
#' \dontrun{
#' # Get core brand colours
#' c40_colours()
#'
#' # Get qualitative palette for categorical data
#' c40_colours("qualitative")
#'
#' # Get light tints for backgrounds
#' c40_colours("core", tint = "light")
#'
#' # Get divergent palette for positive/negative data
#' c40_colours("divergent")
#' }
#'
#' @export
c40_colours <- function(palette = "core", tint = "core", names = TRUE) {
  brand <- c40_brand("color")

  if (palette == "all") {
    return(brand)
  }

  # Handle data visualisation palettes
  if (palette %in% c("qualitative", "sequential", "divergent", "dichotomous")) {
    dataviz <- brand$dataviz

    if (palette == "sequential") {
      # Default to blue sequential
      cols <- dataviz$sequential$blue
    } else {
      cols <- dataviz[[palette]]
    }

    if (names && palette == "qualitative") {
      names(cols) <- c("yellow", "blue", "green", "red", "purple", "navy", "forest")
    }

    return(unlist(cols))
  }

  # Handle core palette with tints
  if (palette == "core") {
    pal <- brand$palette

    # Colours with tints
    colours_with_tints <- c("yellow", "blue", "green", "red", "purple")
    colours_without_tints <- c("navy", "forest")

    if (tint == "core") {
      cols <- c(
        sapply(colours_with_tints, function(x) pal[[x]]$core),
        sapply(colours_without_tints, function(x) pal[[x]]$core)
      )
    } else if (tint %in% c("mid", "light")) {
      # Only colours with tints
      cols <- sapply(colours_with_tints, function(x) {
        val <- pal[[x]][[tint]]
        if (is.null(val)) pal[[x]]$core else val
      })
    } else {
      stop(
        sprintf("Invalid tint '%s'. Options are: 'core', 'mid', 'light'", tint),
        call. = FALSE
      )
    }

    if (!names) {
      cols <- unname(cols)
    }

    return(cols)
  }

  # Handle individual colour requests
  if (palette %in% names(brand$palette)) {
    col_def <- brand$palette[[palette]]

    if (tint %in% names(col_def)) {
      return(col_def[[tint]])
    } else if (tint == "core" && "core" %in% names(col_def)) {
      return(col_def$core)
    } else {
      return(col_def)
    }
  }

  stop(
    sprintf("Unknown palette '%s'. ", palette),
    "Options are: 'core', 'qualitative', 'sequential', 'divergent', ",
    "'dichotomous', 'all', or a colour name (yellow, blue, etc.)",
    call. = FALSE
  )
}


#' Get C40 Brand Fonts
#'
#' Retrieves the C40 brand typography settings.
#'
#' @param element Character. The typography element to retrieve. Options are:
#'   "base", "headings", "monospace", or \code{NULL} for all settings.
#'
#' @return Character string with font name, or list of all typography settings.
#'
#' @examples
#' \dontrun{
#' # Get base font
#' c40_fonts()
#'
#' # Get heading font
#' c40_fonts("headings")
#'
#' # Get all typography settings
#' c40_fonts(NULL)
#' }
#'
#' @export
c40_fonts <- function(element = "base") {
  typography <- c40_brand("typography")

  if (is.null(element)) {
    return(typography)
  }

  if (element %in% names(typography$fonts)) {
    return(typography$fonts[[element]])
  }

  stop(
    sprintf("Unknown font element '%s'. ", element),
    "Options are: 'base', 'headings', 'monospace'",
    call. = FALSE
  )
}


#' Get Text Colour for Background
#'
#' Determines the appropriate text colour (black or white) for a given
#' background colour based on C40 accessibility guidelines.
#'
#' @param background Character. A hex colour code for the background.
#'
#' @return Character. Either "#000000" (black) or "#FFFFFF" (white).
#'
#' @examples
#' \dontrun{
#' # Navy background needs white text
#' c40_text_colour("#053D6B")
#' # Returns "#FFFFFF"
#'
#' # Yellow background needs black text
#' c40_text_colour("#FED939")
#' # Returns "#000000"
#' }
#'
#' @export
c40_text_colour <- function(background) {
  accessibility <- c40_brand("accessibility")

  # Normalise input to uppercase

background <- toupper(background)

  # Check against white text backgrounds
  white_text_bgs <- toupper(accessibility$text_on_background$white_text)

  if (background %in% white_text_bgs) {
    return("#FFFFFF")
  }

  # Default to black text
  return("#000000")
}


#' Get C40 Brand Path
#'
#' Returns the file path to the C40 brand configuration file. Useful for
#' integrating with Quarto documents or other tools that need the file path.
#'
#' @return Character. The file path to `_brand.yml`.
#'
#' @examples
#' \dontrun{
#' # Get path for Quarto integration
#' brand_path <- c40_brand_path()
#' }
#'
#' @export
c40_brand_path <- function() {
  path <- system.file("brand", "_brand.yml", package = "c40tools")

  if (path == "") {
    stop(
      "Brand configuration file not found. ",
      "Please ensure the c40tools package is properly installed.",
      call. = FALSE
    )
  }

  path
}
