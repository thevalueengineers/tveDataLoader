\name{read_sav}
\alias{read_sav}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Read in SPSS .sav files and convert variable names to lower case
}
\description{Wrapper around haven::read_sav() and stringr::str_to_lower()
}
\usage{
read_sav(filepath)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{filepath}{
Filepath, including filename, of an SPSS .sav file
}
}
\value{
An object of class .tibble
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (filepath)
{
    dat <- haven::read_sav(filepath)
    names(dat) <- stringr::str_to_lower(names(dat))
    return(dat)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
