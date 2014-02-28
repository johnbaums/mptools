\name{mpcoords}
\alias{mpcoords}
\title{Back-transform RAMAS Metapop coordinates}
\usage{
mpcoords(mp, asc, cell.length, plot = TRUE)
}
\arguments{
  \item{mp}{A character string containing the path to a
  RAMAS Metapop .mp file.  E.g. file='/path/to/metapop.mp'}

  \item{asc}{A character string containing the path to any
  of the ASCII grids that were used by RAMAS Spatial Data
  for patch identificaion. E.g.  file='/path/to/grid.asc'}

  \item{cell.length}{Numeric. The cell length of the grid,
  as specified in RAMAS Spatial Data (note: this may be
  different to the native resolution of the grids).}

  \item{plot}{Logical. Should the points be plotted?
  Default is \code{TRUE}.}
}
\value{
A \code{data.frame} containing the names of all populations
referred to in the .mp file, as well as their coordinates
(in both Metapop and original coordinate systems).
}
\description{
Extracts population coordinates from a RAMAS Metapop .mp
file, and converts them back to the coordinate system of
the original habitat suitability grids (i.e. the grids
supplied to the RAMAS patch-identification module,
patch.exe or, in more recent versions of RAMAS GIS,
SpatialData.exe).
}
\note{
This has been tested for RAMAS version 5.1, and may produce
unexpected results for other versions. Please verify that
the returned coordinates are sensible by referring to the
plot that is returned by this function.
}
\examples{
mp <- system.file('litspe.mp', package='mptools')
asc <- system.file('litspe_2000.asc', package='mptools')
coords <- mpcoords(mp, asc, 9.975)
}
\seealso{
\code{\link{mp2shp}}
}

