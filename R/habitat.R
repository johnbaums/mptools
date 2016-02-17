#' Hypothetical carrying capacity surfaces
#'
#' This \code{RasterStack} refers to 100 GeoTIFF raster files installed with 
#' \code{mptools}. Each raster represents carrying capacity across the landscape
#' for a given year, with the first year being 2000 and the last year being 
#' 2099. Raster layers have resolution ~10 km (9975 m), and their coordinates
#' are described by the Australian Albers CRS (EPSG: 3577).
#'
#' @docType data
#' @format A \code{RasterStack} with 52 rows, 51 columns, and 100 layers.
"habitat"
