#' Animate the output of a RAMAS Metapop simulation.
#' 
#' Mean population size is indicated by point color, and is overlaid on 
#' temporally-dynamic grids of, e.g., habitat suitability.
#' 
#' @param res An object containing the results of a RAMAS Metapop simulation. 
#'   This object can be created by using \code{\link{mpresults}}.
#' @param coords An object containing population coordinates. This object can be
#'   created by using \code{\link{mpcoords}}.
#' @param habitat Either a file path containing habitat grids (names of grid 
#'   files must end in an underscore followed by a number, e.g. 
#'   litspe_2000.asc), or a RasterStack or RasterBrick object. The number of 
#'   files, or Raster* layers, should equal the number of simulation time steps.
#'   If a file path is provided, files are ordered by the numeric component of 
#'   their names.
#' @param outfile A character string giving the desired output path and 
#'   filename.
#' @param zlim A numeric vector of length 2 giving the lower and upper limits of
#'   the color scale indicating habitat quality.
#' @param axes Logical. Should axes be drawn?
#' @param col.regions A \code{\link{colorRampPalette}} function that will be 
#'   used to generate the colour ramp for grids. If \code{NULL}, a default 
#'   colour ramp based on \code{\link{terrain.colors}} is used.
#' @param col.points A \code{\link{colorRampPalette}} function that will be used
#'   to generate the colour ramp for points. These colours will be interpolated 
#'   into 100 colours, which indicate relative mean population size, ranging 
#'   from 1 (first element of the colour ramp) to the maximum mean population 
#'   size that exists in the simulation output. If \code{NULL}, a default colour
#'   ramp ranging from white to black is used.
#' @param height Numeric. The height of the animation, in pixels. Default is 
#'   800.
#' @param width Numeric. The width of the animation, in pixels. Default is 820.
#' @param interval The time interval of the animation, in seconds. Default is 
#'   0.05, i.e. 20 frames per second.
#' @return \code{NULL}. The animation is saved as an animated .gif file at the
#'   specified path (\code{outfile}).
#' @keywords spatial
#' @seealso \code{\link{mp2shp}}
#' @export
#' @examples 
#' mp <- system.file('litspe.mp', package='mptools')
#' res <- mpresults(mp)
#' asc <- system.file('litspe_2000.asc', package='mptools')
#' coords <- mpcoords(mp, asc, 9.975)
#' tmp <- file.path(tempdir(), 'example.gif')
#' 
#' # Provide a file path containing habitat grids
#' mp_animate(res, coords, habitat=system.file(package='mptools'), outfile=tmp, zlim=c(0, 1225))
#' 
#' # Provide a RasterStack containing habitat grids.
#' grids <- list.files(system.file(package='mptools'), patt='_[0-9]+\\\\.asc$', full.names=TRUE)
#' library(raster)
#' s <- stack(grids)
#' mp_animate(res, coords, habitat=s, outfile=tmp)
mp_animate <- function (res, coords, habitat, outfile, zlim, axes = FALSE, col.regions = NULL, 
                        col.pts = NULL, height = 800, width = 820, interval = 0.05, pt.cex=0.85) 
{
  require(raster)
  require(animation)
  require(rasterVis)
  require(sp)
  require(grid)
  if (!is(habitat, "Raster")) {
    if (is.character(habitat)) {
      f <- list.files(habitat, pattern = "_[0-9]+\\.(asc|tif|grd)$", 
                      full.names = TRUE)
      if (length(f) == 0) 
        stop("habitat must be either a Raster* object or a file path containing .asc, .tif, or .grd files.")
      f <- f[order(gsub(".*_([0-9]+)\\.(asc|tif|grd)$", 
                        "\\1", f))]
      message(sprintf("Creating RasterStack from files found in %s", 
                      habitat))
      habitat <- stack(f)
    }
    else stop("habitat must be either a Raster* object or a file path containing .asc, .tif, or .grd files.")
  }
  if (is.null(col.regions))   
    col.regions <- colorRampPalette(c('#AAAAAA', rev(terrain.colors(10))[-1]))
  if (is.null(col.pts)) 
    col.pts <- colorRampPalette(c("white", "black"))
  N <- res$results[, "mean", ][, -grep("ALL", dimnames(res$results)[[3]])]
  Nmax <- max(N, na.rm = TRUE)
  Nscaled <- ceiling(N * 100/Nmax)
  coordinates(coords) <- ~x + y
  e <- extent(habitat)
  message("Creating gif animation.")
  saveGIF({
    ani.options(interval = interval, nmax = nlayers(habitat), 
                outdir = normalizePath(dirname(outfile)))
    par(mar = c(3, 3, 2, 0.5), mgp = c(2, 0.5, 0), cex.main = 1)
    for (i in 1:nlayers(habitat)) {
      coords.exist <- coords[coords$pop %in% names(which(Nscaled[i, 
                                                                 ] > 0)), ]
      Nscaled.exist <- Nscaled[i, coords.exist$pop]
      print(levelplot(habitat, layers = i, col.regions = col.regions, 
                      margin = FALSE, at = seq(zlim[1], zlim[2], length.out=10), scales = list(draw = axes), 
                      ylim = c(e@ymin - 0.1 * (e@ymax - e@ymin), e@ymax), 
                      panel = function(...) {
                        panel.levelplot.raster(...)
                        sp.points(coords.exist, pch = 21, cex = pt.cex, 
                                  col = 1, fill = col.pts(100)[Nscaled.exist], 
                                  data = list(Nscaled.exist = Nscaled.exist, 
                                              coords.exist = coords.exist, col.pts = col.pts))
                        grid.segments(0.1, 0.05, 0.9, 0.05, gp = gpar(lwd = 3))
                        grid.segments(seq(0.1, 0.9, length.out = 11), 
                                      unit(0.05, "npc") - unit(1.5, "mm"), seq(0.1, 
                                                                               0.9, length.out = 11), unit(0.05, "npc") + 
                                        unit(1.5, "mm"), gp = gpar(lwd = 3))
                        grid.text(seq(2000, 2100, length.out = 11), 
                                  seq(0.1, 0.9, 0.08), 0.05, vjust = 2)
                        grid.points(seq(0.1, 0.9, length.out = 101)[i], 
                                    0.05, pch = 20, default.units = "npc")
                      }))
    }
  }, movie.name = basename(outfile), ani.height = height, 
          ani.width = width)
}
