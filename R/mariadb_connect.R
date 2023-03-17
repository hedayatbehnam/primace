#' MariaDB connection
#' 
#' connection to mariadb database
#' 
#' @param db database
#' @param usr root
#' @param tbl table
#' 
#' @return connection
#' 
#' @import RMariaDB
#' 
#' @noRd
mariadb_connect <- function(..., 
    db = suppressWarnings(system("printenv MARIADB_DB", intern = T)), 
    usr = suppressWarnings(system("printenv MARIADB_USR", intern = T)), 
    tbl = suppressWarnings(system("printenv MARIADB_TBL", intern = T)), 
    pass = suppressWarnings(system("printenv MARIADB_PW", intern = T)),
    host = suppressWarnings(system("printenv MARIADB_HOST", intern = T)),
    port = suppressWarnings(system("printenv MARIADB_PORT", intern = T))){
  
  conn <- dbConnect(RMariaDB::MariaDB(), user=usr, password=pass,
                   dbname=db, host= host, port=port)
  req <- dbSendQuery(conn, paste("SELECT * FROM",db))
  rs <- dbFetch(req)
  
  credentials <- tibble(
    username_id = rs$user,
    passod = rs$pass,
    permission = rs$permission
  )
  rm(list(req,rs))
  dbDisconnect(conn)
  return (credentials)
}



