#' Back-transform RAMAS Metapop coordinates
#' 
#' Extracts population coordinates from a RAMAS Metapop .mp file, and converts 
#' them back to the coordinate system of the original habitat suitability grids 
#' (i.e. the grids supplied to the RAMAS patch-identification module, patch.exe 
#' or, in more recent versions of RAMAS GIS, SpatialData.exe).
#' 
#' @param mp A character string containing the path to a RAMAS Metapop .mp file.
#' @param r Either a character string containing the path to any of the raster
#'   files that were used by RAMAS Spatial Data for patch identification, or a
#'   \code{Raster*} object that was used for that purpose.
#' @param cell.length Numeric. The cell length of the grid, as specified in 
#'   RAMAS Spatial Data (note: this may be different to the native resolution of
#'   the grids).
#' @param plot Logical. Should the points be plotted? If \code{r} is a 
#'   \code{Raster*} object with more than one layer, the first layer will be 
#'   plotted.
#' @return A \code{data.frame} containing the names of all populations referred 
#'   to in the .mp file, as well as their coordinates (in both Metapop and 
#'   original coordinate systems).
#' @seealso \code{\link{mp2sp}}
#' @note This has been tested for RAMAS version 5.1, and may produce unexpected
#'   results for other versions. Please verify that the returned coordinates are
#'   sensible by referring to the plot that is returned by this function.
#' @importFrom raster raster cellStats xmin ymin xres
#' @importFrom rasterVis levelplot
#' @importFrom latticeExtra layer
#' @importFrom sp sp.points SpatialPoints
#' @importFrom utils read.csv
#' @importFrom grDevices colorRampPalette terrain.colors
#' @importFrom methods is
#' @export
#' @examples
#' mp <- system.file('example.mp', package='mptools')
#' coords <- mp2xy(mp, habitat, 9.975)
mp2xy <- function (mp, r, cell.length, plot = TRUE) {
  if(!file.exists(mp)) stop(mp, ' doesn\'t exist.', call.=FALSE)
  metapop <- readLines(mp)[-(1:6)]
  if (!length(grep("\\-End of file\\-", metapop[length(metapop)]))) {
    stop(sprintf("Expected final line of %s to contain \"-End of file-\"", 
                 mp))
  }
  pops <- metapop[39:(grep('^Migration$', metapop) - 1)]
  pops <- utils::read.csv(text = pops, stringsAsFactors = FALSE, 
                   header = FALSE)[, 1:3]
  if (!methods::is(r, "Raster")) r <- raster::raster(r)
  x0 <- raster::xmin(r)
  y0 <- raster::ymin(r)
  cellsize <- raster::xres(r)
  nr <- nrow(r)
  y1 <- y0 + nr * cellsize
  colnames(pops) <- c("pop", "x_mp", "y_mp")
  scl <- cellsize/cell.length
  pops$x <- (x0 - 0.5 * cellsize) + scl * pops$x_mp
  pops$y <- (y1 + 0.5 * cellsize) - scl * pops$y_mp
  if (plot) {
    p <- rasterVis::levelplot(
      r[[1]], col.regions=viridis::viridis(1000), 
      margin=FALSE, colorkey=list(height=0.6),
      at=seq(raster::cellStats(r[[1]], min), 
             raster::cellStats(r[[1]], max), len=1001)) + 
      latticeExtra::layer(sp::sp.points(
        sp::SpatialPoints(pops[, c('x', 'y')]), col=1, fill='#ffffff80', pch=21), 
        data=list(pops=pops))
    print(p)
  }
  return(pops)
}
