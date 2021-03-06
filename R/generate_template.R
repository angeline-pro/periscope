# TEMPLATE SETUP FUNCTIONS ------

#' Create a new templated framework application
#'
#' Creates ready-to-use templated application files using the periscope
#' framework.  The application can be created either empty or with a
#' sample/documented example application.
#'
#' @param name name for the new application and directory
#' @param location base path for creation of \code{name}
#' @param sampleapp whether to create a sample shiny application
#'
#' @section Name:
#' The \code{name} directory must not exist in \code{location}.  If the code
#' detects that this directory exists it will abort the creation process with
#' a warning and will not create an application template.
#'
#' Use only filesystem-compatible characters in the name (ideally w/o spaces)
#'
#' @section Directory Structure:
#'
#' \preformatted{
#' name
#'  -- www (supporting shiny files)
#'  -- program (user application)
#'  -- -- data (user application data)
#'  -- -- fxn  (user application function)
#'  -- log (log files)
#' }
#'
#' @section File Information:
#'
#' All user application creation and modifications will be done in
#' the \strong{program} directory.  The names & locations
#' of the framework-provided .R files should not be changed or the framework
#' will fail to work as expected. \cr
#' \cr
#' \strong{\emph{name/program}/ui_body.R} :\cr
#' Create body UI elements in this file and register them with the
#' framework using a call to \link[periscope]{add_ui_body} \cr
#' \cr
#' \strong{\emph{name/program}/ui_sidebar.R} :\cr
#' Create sidebar UI elements in this file and register them with the
#' framework using a call to \link[periscope]{add_ui_sidebar_basic} or
#' \link[periscope]{add_ui_sidebar_advanced} \cr
#' \cr
#' \strong{\emph{name/program/data}} directory :\cr
#' Use this location for data files.  There is a \strong{.gitignore} file
#' included in this directory to prevent accidental versioning of data\cr
#' \cr
#' \strong{\emph{name/program}/global.R} :\cr
#' Use this location for code that would have previously resided in global.R
#' and for setting application parameters using
#' \link[periscope]{set_app_parameters}.  Anything placed in this file will
#' be accessible across all user sessions as well as within the UI context. \cr
#' \cr
#' \strong{\emph{name/program}/server_global.R} :\cr
#' Use this location for code that would have previously resided in server.R
#' above (ie outside of) the call to \code{shinyServer(...)}. Anything placed
#' in this file will be accessible across all user sessions. \cr
#' \cr
#' \strong{\emph{name/program}/server_local.R} :\cr
#' Use this location for code that would have previously resided in server.R
#' inside of the call to \code{shinyServer(...)}.  Anything placed in this
#' file will be accessible only within a single user session.\cr
#' \cr
#' \cr
#' \strong{Do not modify the following files}: \cr
#' \preformatted{
#' name\\global.R
#' name\\server.R
#' name\\ui.R
#' name\\www\\img\\loader.gif
#' name\\www\\img\\tooltip.png
#' }
#'
#'@examples
#' # sample app named 'mytestapp' created in a temp dir
#' create_new_application(name = 'mytestapp', location = tempdir(), sampleapp = TRUE)
#' 
#' # blank app named 'myblankapp' created in a temp dir
#' create_new_application(name = 'mytestapp', location = tempdir())
#'
#' @export
create_new_application <- function(name, location, sampleapp = FALSE) {
    usersep <- .Platform$file.sep
    newloc <- paste(location, name, sep = usersep)

    if (dir.exists(newloc)) {
        warning("Framework creation could not proceed, path=<",
                newloc, "> already exists!")
    }
    else if (!(dir.exists(location))) {
        warning("Framework creation could not proceed, location=<",
                location, "> does not exist!")
    }
    else {
        .create_dirs(newloc, usersep)
        .copy_fw_files(newloc, usersep)
        .copy_program_files(newloc, usersep, sampleapp)

        message("Framework creation was successful.")
    }
    invisible(NULL)
}


# Create Directories ----------------------------
.create_dirs <- function(newloc, usersep) {
    dir.create(newloc)
    dir.create(paste(newloc, "www", sep = usersep))
    dir.create(paste(newloc, "www", "css", sep = usersep))
    dir.create(paste(newloc, "www", "js", sep = usersep))
    dir.create(paste(newloc, "www", "img", sep = usersep))

    dir.create(paste(newloc, "program", sep = usersep))
    dir.create(paste(newloc, "program", "data", sep = usersep))
    dir.create(paste(newloc, "program", "fxn", sep = usersep))

    dir.create(paste(newloc, "log", sep = usersep))

    #safety for data directory - create .gitignore
    writeLines(c("*", "*/", "!.gitignore"),
               con = paste(newloc, "program", "data", ".gitignore",
                           sep = usersep))

    return()
}

# Create Framework Files ----------------------------
.copy_fw_files <- function(newloc, usersep) {
    files <- c("global.R",
               "server.R",
               "ui.R")

    for (file in files) {
        writeLines(readLines(
            con = system.file("fw_templ", file, package = "periscope")),
            con = paste(newloc, file, sep = usersep))
    }

    #subdir copies
    imgs <- c("loader.gif", "tooltip.png")
    for (file in imgs) {
        writeBin(readBin(
            con = system.file("fw_templ", "www", file,
                              package = "periscope"),
            what = "raw", n = 1e6),
            con = paste(newloc, "www", "img", file, sep = usersep))
    }

    return()
}

# Create Program Files ----------------------------
.copy_program_files <- function(newloc, usersep, sampleapp) {
    files <- c("global.R",
               "server_global.R",
               "server_local.R",
               "ui_body.R",
               "ui_sidebar.R")

    targetdir <- paste(newloc, "program", sep = usersep)
    sourcedir <- paste("fw_templ",
                       ifelse(sampleapp, "p_example", "p_blank"),
                       sep = usersep)

    for (file in files) {
        writeLines(readLines(
            con = system.file(sourcedir, file, package = "periscope")),
            con = paste(targetdir, file, sep = usersep))
    }

    #subdir copies for sampleapp
    if (sampleapp) {
        supporting_files <- list("example.csv"       = "data",
                                 "program_helpers.R" = "fxn",
                                 "plots.R"           = "fxn")
        for (file in names(supporting_files)) {
            writeLines(readLines(
                con = system.file(sourcedir, file,
                                  package = "periscope")),
                con = paste(targetdir, unlist(supporting_files[file], use.names = F), file, sep = usersep))
        }
    }

    return()
}
