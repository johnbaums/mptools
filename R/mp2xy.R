#' Back-transform RAMAS Metapop coordinates
#' 
#' Extracts population coordinates from a RAMAS Metapop .mp file, and converts 
#' them back to the coordinate system of the original habitat suitability grids 
#' (i.e. the grids supplied to the RAMAS patch-identification module, patch.exe 
#' or, in more recent versions of RAMAS GIS, SpatialData.exe).
#' 
#' @param mp A character string containing the path to a RAMAS Metapop .mp file.
#'   E.g. file='/path/to/metapop.mp'
#' @param asc A character string containing the path to any of the ASCII grids 
#'   that were used by RAMAS Spatial Data for patch identificaion. E.g. 
#'   file='/path/to/grid.asc'
#' @param cell.length Numeric. The cell length of the grid, as specified in 
#'   RAMAS Spatial Data (note: this may be different to the native resolution of
#'   the grids).
#' @param plot Logical. Should the points be plotted? Default is \code{TRUE}.
#' @return A \code{data.frame} containing the names of all populations referred 
#'   to in the .mp file, as well as their coordinates (in both Metapop and 
#'   original coordinate systems).
#' @seealso \code{\link{mp2shp}}
#' @note This has been tested for RAMAS version 5.1, and may produce unexpected
#'   results for other versions. Please verify that the returned coordinates are
#'   sensible by referring to the plot that is returned by this function.
#' @export
#' @examples
#' mp <- system.file('example.mp', package='mptools')
#' asc <- system.file('example_001.asc', package='mptools')
#' coords <- mp2xy(mp, asc, 9.975)
mp2xy <- function (mp, asc, cell.length, plot = TRUE) {
  if(!file.exists(mp)) stop(mp, ' doesn\'t exist.', call.=FALSE)
  metapop <- readLines(mp)[-(1:6)]
  if (!length(grep("\\-End of file\\-", metapop[length(metapop)]))) {
    stop(sprintf("Expected final line of %s to contain \"-End of file-\"", 
                 mp))
  }
  pops <- metapop[39:(grep('^Migration$', metapop) - 1)]
  pops <- read.csv(text = pops, stringsAsFactors = FALSE, 
                   header = FALSE)[, 1:3]
  
  header <- read.table(asc, nrows = 6, row.names = 1)
  x0 <- header[grep("xll", row.names(header), ignore.case = TRUE),] 
  # RAMAS treats both xllcorner and xllcenter as the cell centre (same for yll)
  y0 <- header[grep("yll", row.names(header), ignore.case = TRUE),]
  cellsize <- header[grep("cellsize", row.names(header), ignore.case = TRUE), ]
  nr <- header[grep("nrows", row.names(header), ignore.case = TRUE), ]
  y1 <- y0 + nr * cellsize
  colnames(pops) <- c("pop", "x_mp", "y_mp")
  scl <- cellsize/cell.length
  pops$x <- (x0 - 0.5 * cellsize) + scl * pops$x_mp
  pops$y <- (y1 + 0.5 * cellsize) - scl * pops$y_mp
  if (plot) 
    plot(pops$y ~ pops$x, pch = 19, cex = 0.1, xlab = "x", 
         ylab = "y", asp = 1, main = basename(mp))
  return(pops)
}
