.onLoad <- function(libname, pkgname) {
  # Load Google fonts for C40 visualisations
  # Figtree is the official C40 font as of September 2025
  # These are loaded silently - if no internet or fonts fail, package still works
  tryCatch({
    sysfonts::font_add_google("Figtree", "Figtree")
    sysfonts::font_add_google("Fira Code", "Fira Code")
    # Keep legacy fonts for backwards compatibility
    sysfonts::font_add_google("Roboto", "Roboto")
  }, error = function(e) {
    # Silently fail if fonts cannot be loaded (no internet, etc.)
    NULL
  })
}
