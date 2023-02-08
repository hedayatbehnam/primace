#' Fetching User Table from Database
#'
#' @param ... key-value extra
#' @param host host of database
#' @param port port of database
#' @param username username of database
#' @param password password of database
#' @param table table of interest
#' @param db name of database
#'
#' @return users table as dataframe
#'
#' @noRd
user_fetch <- function(..., host, port=0, username, password, db, table){
  conn <- RMariaDB::dbConnect(RMariaDB::MariaDB(), db=db,host=host, port=port, password = password)
  user_data <- RMariaDB::dbReadTable(conn = conn, name = table)
  return (list(conn=conn, user_data=user_data))
}
