options(repos = c(RSPM = "https://packagemanager.rstudio.com/all/__linux__/focal/latest")) # https://packagemanager.rstudio.com/client/#/repos/1/overview
dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)
.libPaths(c(Sys.getenv("R_LIBS_USER"), .libPaths()))
install.packages("renv") # https://cloud.r-project.org/web/packages/renv/index.html
