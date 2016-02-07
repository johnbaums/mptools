#' Create shapefile containing Metapop population centroids
#' 
#' Creates a shapefile (.shp, and associated .shx and .dbf files) containing a 
#' point representing the centroid of each population. Attributes of each point 
#' include the population's name (\code{pop}), and and the mean population size 
#' at each time step.
#' 
#' @param mp A RAMAS Metapop .mp file containing simulation results.
#' @param coords An object containing population coordinates. This object can be
#'   created by using \code{\link{mp2xy}}
#' @param outfile The desired output filename (including full path, and without 
#'   file extension).
#' @param start The value of the first timestep. If timesteps are not in 
#'   increments of 1, it may be best to use \code{start=1}, in which case 'time'
#'   in the resulting shapefile's attribute table will refer to the timestep 
#'   number.
#' @return \code{NULL}. Three files are created: outfile.shp, outfile.shx and
#'   outfile.dbf.
#' @keywords spatial
#' @seealso \code{\link{mp2xy}}
#' @importFrom sp coordinates
#' @importFrom rgdal writeOGR
#' @export
#' @examples
#' mp <- system.file('example.mp', package='mptools')
#' r <- system.file('example_001.asc', package='mptools')
#' coords <- mp2xy(mp, r, 9.975)
#' tmp <- tempfile() 
#' mp2shp(mp, coords, tmp, start=2000) # file will be created in tempdir()
mp2shp <- function(mp, coords, outfile, start) {
  errmsg <- NULL
  if (file.exists(paste(outfile, 'shp', sep='.'))) {
    errmsg <- c(errmsg, sprintf('\nFile %s.shp already exists.', outfile))
  }
  if (file.exists(paste(outfile, 'shx', sep='.'))) {
    errmsg <- c(errmsg, sprintf('\nFile %s.shx already exists.', outfile))
  }
  if (file.exists(paste(outfile, 'dbf', sep='.'))) {
    errmsg <- c(errmsg, sprintf('\nFile %s.dbf already exists.', outfile))
  }
  if(length(errmsg)) stop(errmsg)
  res <- results(mp)
  sites <- coords[, c('pop', 'x', 'y')]
  N <- as.data.frame(t(res$results[, 'mean', -1]))
  names(N) <- start + seq_along(N) - 1
  if(!identical(row.names(N), sites$pop)) 
    stop('Something went wrong. Please contact the package maintainer.')
  shp <- cbind(sites, N)
  sp::coordinates(shp) <- ~x+y
  rgdal::writeOGR(shp, dirname(outfile), basename(outfile), 'ESRI Shapefile') 
  if(file.exists(paste0(outfile, '.shp'))) {
    message(sprintf('File %s.shp created.', outfile))
  } else {
    message(sprintf('There was a problem creating %s.shp.', outfile))
  } 
}
