#' Clean text function:
#' @description
#' Removes accents and umlaut from vowels. E.g.: "ÿÚòâ" into "yUoa".
#'
#' @param text character value
#' @examples
#' clean_text("ÿÚòâ") #"yuoa"
#'
#'@export
clean_text <- function(text) {

  accents_df <- tibble::tibble(
    ansi = c("á", "á", "à", "â", "ã", "ä", "å",
             "à", "â", "ã", "ä", "å", "é", "é", "è", "ê", "ë", "è",
             "ê", "ë", "í", "í", "ì", "î", "ï", "ì", "î", "ï", "ó",
             "ó", "ò", "ô", "õ", "ö", "ð", "ò", "ô", "õ", "ö", "ú",
             "ú", "ù", "û", "ü", "ù", "û", "ü", "ý", "ý", "ÿ"),
    clean = c("a", "a", "a", "a", "a", "a", "a", "a", "a",
               "a", "a", "a", "e", "e", "e", "e", "e", "e", "e", "e", "i",
               "i", "i", "i", "i", "i", "i", "i", "o", "o", "o", "o", "o",
               "o", "o", "o", "o", "o", "o", "u", "u", "u", "u", "u", "u",
               "u", "u", "y", "y", "y"))

  mgsub::mgsub(text, pattern = c(accents_df$ansi, toupper(accents_df$ansi)),
               replacement = c(accents_df$clean, toupper(accents_df$clean)), fixed = T)
}
