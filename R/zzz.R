.onLoad <- function(libname, pkgname) {
 # Load Google fonts for C40 visualisations
 # These are loaded silently - if no internet or fonts fail, package still works
 tryCatch({
 sysfonts::font_add_google("Roboto", "Roboto")
 sysfonts::font_add_google("Encode Sans", "Encode Sans Normal")
 sysfonts::font_add_google("Fira Mono", "monospace")
 }, error = function(e) {
 # Silently fail if fonts cannot be loaded (no internet, etc.)
 NULL
 })
}
