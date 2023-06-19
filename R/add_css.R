#' Add document's css style parameters
#'
#' @return a style.css file
#' @export
#'
#' @examples
#' add_css()
add_css <- function(){

  tableHTML::make_css(
    list('body',
         c('font-family', 'font-size'),
         c('Fira mono', '10pt')),
    list('h1',
         c('font-size'),
         c('24')),
    list('h2',
         c('font-size'),
         c('18')),
    list('h3',
         c('font-size'),
         c('14')),
    list('h4, h5, h6',
         c('font-size'),
         c('12')),
    file = 'style.css'
    )
}

