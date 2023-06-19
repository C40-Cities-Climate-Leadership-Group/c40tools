pkg_resource <- function(...) {
  system.file("resources", ..., package = "c40tools", mustWork = TRUE)
}
