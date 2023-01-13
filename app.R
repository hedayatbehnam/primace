libs <- c("shiny", "devtools", "rsconnect")
invisible(suppressMessages(sapply(libs, library, character.only=T)))
devtools::load_all(".")
primace::primace_init()
