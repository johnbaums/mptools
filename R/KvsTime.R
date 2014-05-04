#' Plot carrying capacity vs time
#' 
#' Plot each population's carrying capacity vs time.
#' 
#' @param kch The R object holding kch data returned by \link{mpkch}.
#' @param filename A character string giving the filename (with extension ".pdf") to save the plot to.
#' @param layout The number of columns and row of plots (default = 5 columns, 10 rows).
#' @param ... Additional arguments to \link{xyplot.zoo}.
#' @return A pdf file with a plot for each population showing carrying capacity over time.
#' @export
KvsTime <- function(kch, filename, layout=c(5, 10), ...) {
  require(zoo)
  require(lattice)
  if (!grepl('\\.pdf$', filename)) filename <- paste0(file, '.pdf')
  pdf(filename, paper='a4', width=8, height=11)
  print(xyplot(zoo(kch), layout=layout, 
               scales=list(alternating=FALSE, tck=c(1, 0), cex=0.8, rot=0),
               ylab='Carrying capacity', ...))
  dev.off()
}