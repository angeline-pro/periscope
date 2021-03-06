% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_template.R
\name{create_new_application}
\alias{create_new_application}
\title{Create a new templated framework application}
\usage{
create_new_application(name, location, sampleapp = FALSE)
}
\arguments{
\item{name}{name for the new application and directory}

\item{location}{base path for creation of \code{name}}

\item{sampleapp}{whether to create a sample shiny application}
}
\description{
Creates ready-to-use templated application files using the periscope
framework.  The application can be created either empty or with a
sample/documented example application.
}
\section{Name}{

The \code{name} directory must not exist in \code{location}.  If the code
detects that this directory exists it will abort the creation process with
a warning and will not create an application template.

Use only filesystem-compatible characters in the name (ideally w/o spaces)
}

\section{Directory Structure}{


\preformatted{
name
 -- www (supporting shiny files)
 -- program (user application)
 -- -- data (user application data)
 -- -- fxn  (user application function)
 -- log (log files)
}
}

\section{File Information}{


All user application creation and modifications will be done in
the \strong{program} directory.  The names & locations
of the framework-provided .R files should not be changed or the framework
will fail to work as expected. \cr
\cr
\strong{\emph{name/program}/ui_body.R} :\cr
Create body UI elements in this file and register them with the
framework using a call to \link[periscope]{add_ui_body} \cr
\cr
\strong{\emph{name/program}/ui_sidebar.R} :\cr
Create sidebar UI elements in this file and register them with the
framework using a call to \link[periscope]{add_ui_sidebar_basic} or
\link[periscope]{add_ui_sidebar_advanced} \cr
\cr
\strong{\emph{name/program/data}} directory :\cr
Use this location for data files.  There is a \strong{.gitignore} file
included in this directory to prevent accidental versioning of data\cr
\cr
\strong{\emph{name/program}/global.R} :\cr
Use this location for code that would have previously resided in global.R
and for setting application parameters using
\link[periscope]{set_app_parameters}.  Anything placed in this file will
be accessible across all user sessions as well as within the UI context. \cr
\cr
\strong{\emph{name/program}/server_global.R} :\cr
Use this location for code that would have previously resided in server.R
above (ie outside of) the call to \code{shinyServer(...)}. Anything placed
in this file will be accessible across all user sessions. \cr
\cr
\strong{\emph{name/program}/server_local.R} :\cr
Use this location for code that would have previously resided in server.R
inside of the call to \code{shinyServer(...)}.  Anything placed in this
file will be accessible only within a single user session.\cr
\cr
\cr
\strong{Do not modify the following files}: \cr
\preformatted{
name\\global.R
name\\server.R
name\\ui.R
name\\www\\img\\loader.gif
name\\www\\img\\tooltip.png
}
}

\examples{
# sample app named 'mytestapp' created in a temp dir
create_new_application(name = 'mytestapp', location = tempdir(), sampleapp = TRUE)

# blank app named 'myblankapp' created in a temp dir
create_new_application(name = 'mytestapp', location = tempdir())

}
