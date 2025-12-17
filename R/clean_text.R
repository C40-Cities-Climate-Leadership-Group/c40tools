#' Clean text by removing accents and umlauts
#'
#' Removes accents and umlauts from vowels, converting them to their
#' ASCII equivalents. Useful for standardising city names and other
#' text data for matching purposes.
#'
#' @param text Character vector to clean.
#'
#' @return Character vector with accents and umlauts removed.
#'
#' @examples
#' clean_text("S\u00e3o Paulo")
#' clean_text("M\u00e9xico")
#' clean_text("Z\u00fcrich")
#'
#' @export
clean_text <- function(text) {

  # Define accented characters using Unicode escapes for portability
 # Lowercase accented vowels
 accents_lower <- c(
 "\u00e1", "\u00e0", "\u00e2", "\u00e3", "\u00e4", "\u00e5",
 "\u00e9", "\u00e8", "\u00ea", "\u00eb",
 "\u00ed", "\u00ec", "\u00ee", "\u00ef",
 "\u00f3", "\u00f2", "\u00f4", "\u00f5", "\u00f6", "\u00f0",
 "\u00fa", "\u00f9", "\u00fb", "\u00fc",
 "\u00fd", "\u00ff"
 )

 # Replacements for lowercase
 replace_lower <- c(
 "a", "a", "a", "a", "a", "a",
 "e", "e", "e", "e",
 "i", "i", "i", "i",
 "o", "o", "o", "o", "o", "o",
 "u", "u", "u", "u",
 "y", "y"
 )

 # Uppercase accented vowels
 accents_upper <- c(
 "\u00c1", "\u00c0", "\u00c2", "\u00c3", "\u00c4", "\u00c5",
 "\u00c9", "\u00c8", "\u00ca", "\u00cb",
 "\u00cd", "\u00cc", "\u00ce", "\u00cf",
 "\u00d3", "\u00d2", "\u00d4", "\u00d5", "\u00d6", "\u00d0",
 "\u00da", "\u00d9", "\u00db", "\u00dc",
 "\u00dd"
 )

 # Replacements for uppercase
 replace_upper <- c(
 "A", "A", "A", "A", "A", "A",
 "E", "E", "E", "E",
 "I", "I", "I", "I",
 "O", "O", "O", "O", "O", "O",
 "U", "U", "U", "U",
 "Y"
 )

 mgsub::mgsub(
 text,
 pattern = c(accents_lower, accents_upper),
 replacement = c(replace_lower, replace_upper),
 fixed = TRUE
 )
}
