RSPM <- c(RSPM = "https://packagemanager.rstudio.com/all/latest")

dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)
.libPaths(c(Sys.getenv("R_LIBS_USER"), .libPaths()))
install.packages("renv", repos = RSPM)
