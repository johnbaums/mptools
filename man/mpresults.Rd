\name{mpresults}
\alias{mpresults}
\title{Extract simulation results from RAMAS Metapop .mp files}
\usage{
mpresults(mp)
}
\arguments{
  \item{mp}{A character string containing the path to a
  RAMAS Metapop .mp file containing simulation results.
  E.g. file='/path/to/metapop.mp'}
}
\value{
A \code{list} containing: \item{results}{An array
containing simulation results extracted from \code{file}.
The number of rows is equal to the number of time steps in
the simulation. The array has four columns, containing
mean, sd, min and max of population size across iterations
at each time step (i.e. each row), and the number of array
slices is equal to the number of populations. The third
dimension is named according to population names (numeric
component only).} \item{minmaxterm}{A matrix containing the
minimum and maximum (across years), and terminal occupancy
for each iteration.} \item{EMA}{The mean minimum abundance
(i.e. the mean, across iterations, of the minimum abundance
for each simulation trajectory).} \item{SDMA}{The standard
deviation of minimum abundance (i.e.  the sd, across
iterations, of the minimum abundance for each simulation
trajectory).} \item{timestamp}{A POSIXlt object
representing the date and time at which the simulation was
completed.} \item{iters}{The number of iterations
performed.}
}
\description{
Extracts population size simulation results (mean, sd, min
and max), including expected minimum abundance (EMA) and
its standard deviation, from a RAMAS Metapop .mp file.
}
\note{
This has been tested for RAMAS version 5.1, and may produce
unexpected results for other versions.
}
\examples{
mp <- system.file('litspe.mp', package='mptools')
res <- mpresults(mp)
str(res)

# look at the simulation results for the first array slice (NB: this slice is
all pops combined):
res$results[,, 1]
# equivalently, subset by name:
res$results[,, 'ALL']
res$results[,, 'Pop 190']
res$results[,, '240A24']
dimnames(res$results)[[3]] # population names

# return a matrix of mean population sizes, where columns represent
populations and rows are time steps:
res$results[, 1, ] # or res$results[, 'mean', ]

# sd across iterations:
res$results[, 2, ] # or res$results[, 'sd', ]

# min pop sizes across iterations:
res$results[, 3, ] # or res$results[, 'min', ]

# max pop sizes across iterations:
res$results[, 4, ] # or res$results[, 'max', ]
}
\seealso{
\code{\link{mpmeta}}
}