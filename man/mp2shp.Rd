\name{mp2shp}
\alias{mp2shp}
\title{Create shapefile containing Metapop population centroids}
\usage{
mp2shp(res, coords, outfile, start)
}
\arguments{
  \item{res}{An object containing the results of a RAMAS
  Metapop simulation.  This object can be created by using
  \code{\link{mpresults}}.}

  \item{coords}{An object containing population
  coordinates. This object can be created by using
  \code{\link{mpcoords}}}

  \item{outfile}{The desired output filename (including
  full path, and without file extension).}

  \item{start}{The value of the first timestep. If
  timesteps are not in increments of 1, it may be best to
  use \code{start=1}, in which case 'time' in the resulting
  shapefile's attribute table will refer to the timestep
  number.}
}
\value{
\code{NULL}. Three files are created: outfile.shp,
outfile.shx and outfile.dbf.
}
\description{
Creates a shapefile (.shp, and associated .shx and .dbf
files) containing a point representing the centroid of each
population. Attributes of each point include the
population's name (\code{pop}), and and the mean population
size at each time step.
}
\examples{
mp <- system.file('litspe.mp', package='mptools')
res <- mpresults(mp)
asc <- system.file('litspe_2000.asc', package='mptools')
coords <- mpcoords(mp, asc, 9.975)
tmp <- tempfile()
mp2shp(res, coords, tmp, start=2000) # file will be created in tempdir()
}
\seealso{
\code{\link{mpcoords}}
}
\keyword{spatial}

