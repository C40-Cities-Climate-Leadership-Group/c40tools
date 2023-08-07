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
    list('tabset ul',
         c('font-family', 'list-style-type', 'margin',
           'padding', 'overflow', 'background-color'),
         c('Fira mono', 'none', '0', '0', 'hidden', 'white')),
    list('tabset ul li a',
         c('float'),
         c('left')),
    list('tabset ul li a',
         c('display', 'color', 'text-align','padding', 'background-color'),
         c('block', 'grey', 'center', '14px 16px', 'white')),
    list('nav li.active a',
         c('baclground-color', 'color'),
         c('#23BCED', 'white')),
    list('nav li a:hover',
         c('baclground-color', 'color'),
         c('#23BCED', 'white')),
    list('nav li.active a:focus',
         c('baclground-color', 'color'),
         c('#23BCED', 'white')),
    list('nav li.active a:hover',
         c('baclground-color', 'color'),
         c('#23BCED', 'white')),
    file = 'style.css'
  )
}


