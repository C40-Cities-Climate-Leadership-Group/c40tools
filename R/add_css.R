#' Add document's CSS style parameters
#'
#' Creates a CSS file with C40 styling for HTML documents. The function
#' generates a `style.css` file in an `html_style` folder and opens it
#' for editing.
#'
#' @return Invisibly returns `NULL`. Called for its side effect of creating
#'   a CSS file.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' add_css()
#' }
add_css <- function() {

  if (!dir.exists("html_style")) {
    dir.create("html_style")
    cat("A html_style folder has been created\n")
  }

  tableHTML::make_css(
    list("html",
         c("scroll-behavior"),
         c("smooth")),
    list("*",
         c("font-family"),
         c("Fira mono")),
    list("body",
         c("font-size", "width", "border", "margin-left", "line-height", "text-align", "text-justify"),
         c("12pt", "1000px", "5px solid black", "190px", "25px", "justify", "inter-word")),
    list("p",
         c("width", "max-width"),
         c("900px", "900px")),
    list("h1",
         c("font-size", "color"),
         c("24", "#23BCED")),
    list("h2",
         c("font-size", "color"),
         c("18", "#23BCED")),
    list("h3",
         c("font-size"),
         c("14")),
    list("h4, h5, h6",
         c("font-size"),
         c("12")),
    list("tabset ul",
         c("font-family", "list-style-type", "margin",
           "padding", "overflow", "background-color"),
         c("Fira mono", "none", "0", "0", "hidden", "white")),
    list("tabset ul li a",
         c("float"),
         c("left")),
    list("tabset ul li a",
         c("display", "color", "text-align", "padding", "background-color"),
         c("block", "grey", "center", "14px 16px", "white")),
    list("nav li.active a",
         c("background-color", "color"),
         c("#23BCED", "white")),
    list("nav li a:hover",
         c("background-color", "color"),
         c("#23BCED", "white")),
    list("nav li.active a:focus",
         c("background-color", "color"),
         c("#23BCED", "white")),
    list("nav li.active a:hover",
         c("background-color", "color"),
         c("#23BCED", "white")),
    file = "html_style/style.css"
  )

  utils::file.edit("html_style/style.css")

  invisible(NULL)
}
