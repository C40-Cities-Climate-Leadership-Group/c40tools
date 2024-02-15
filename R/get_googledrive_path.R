
#' Get your local Google Drive folder
#'
#' @return
#' A path to your local google drive folder
#' @export
#'
#' @examples
#' path <- get_googledrive_path()
get_googledrive_path <- function(){

  user <- stringr::str_remove(path.expand("~"), "/Users/")

  googe_drive_path <- glue::glue(path.expand("~/Library/CloudStorage/GoogleDrive-{user}@c40.org/"))

  return(googe_drive_path)
}
