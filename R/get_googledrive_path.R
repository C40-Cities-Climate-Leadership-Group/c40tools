
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
  user_email_path <- paste0(path.expand("~"), "/Library/CloudStorage/")

  user_email_name <- stringr::str_extract(list.files(user_email_path), "(?<=-)[^@]+(?=@)")

  googe_drive_path <- glue::glue(path.expand("~/Library/CloudStorage/GoogleDrive-{user_email_name}@c40.org/"))

  return(googe_drive_path)
}

