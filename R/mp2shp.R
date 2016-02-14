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
#' @param s_p4s (Optional) The coordinate reference system of the source
#'   cordinates given in \code{coords}. These can be supplied as a \code{CRS} 
#'   object or as a proj4 string.
#' @param t_p4s (Optional) The target coordinate reference system to which
#'   coordinates will be projected, if supplied. These can be supplied as a
#'   \code{CRS} object or as a proj4 string.
#' @return \code{NULL}. Three files are created: outfile.shp, outfile.shx and
#'   outfile.dbf.
#' @keywords spatial
#' @seealso \code{\link{mp2xy}}
#' @importFrom sp coordinates CRS proj4string spTransform
#' @importFrom rgdal writeOGR
#' @importFrom raster crs
#' @export
#' @examples
#' mp <- system.file('example.mp', package='mptools')
#' r <- system.file('example_001.asc', package='mptools')
#' coords <- mp2xy(mp, r, 9.975)
#' tmp <- tempfile() 
#' mp2shp(mp, coords, tmp, start=2000) # file will be created in tempdir()
mp2shp <- function(mp, coords, outfile, start, s_p4s, t_p4s) {
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
  if(!missing('s_p4s')) {
    tryCatch(raster::crs(s_p4s), error=function(e) 
      stop('proj4string not recognised: ', s_p4s, call.=FALSE))
    sp::proj4string(shp) <- s_p4s 
  }
  if(!missing('t_p4s')) {
    if(missing('s_p4s'))
       stop('If t_p4s is supplied, s_p4s must also be supplied', call.=FALSE)
    tryCatch(raster::crs(t_p4s), error=function(e) 
      stop('proj4string not recognised: ', t_p4s, call.=FALSE))
    shp <- sp::spTransform(shp, sp::CRS(t_p4s)) 
  }
  rgdal::writeOGR(shp, dirname(outfile), basename(outfile), 'ESRI Shapefile') 
  if(file.exists(paste0(outfile, '.shp'))) {
    message(normalizePath(outfile, '/', mustWork=FALSE), '.shp created.')
  } else {
    warning(sprintf('There was a problem creating %s.shp.', outfile))
  } 
}
