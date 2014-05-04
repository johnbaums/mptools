#' Plot carrying capacity vs time
#' 
#' Plot each population's carrying capacity vs time.
#' 
#' @param meta The R object holding population info returned by \link{mpmeta}.
#' @param kch The R object holding kch data returned by \link{mpkch}.
#' @param filename A character string giving the filename (with extension ".pdf") to save the plot to.
#' @param samelims (logical) If \code{TRUE}, the y-axis limits will be constant across plots.
#' @param layout The number of columns and row of plots (default = 5 columns, 10 rows).
#' @param ... Additional arguments to \link{xyplot.zoo}.
#' @return A pdf file with a plot for each population showing carrying capacity over time.
#' @export
KvsTime <- function(meta, kch, filename, samelims=FALSE, layout=c(5, 10), ...) {
  require(zoo)
  require(lattice)
  if (!grepl('\\.pdf$', filename)) filename <- paste0(filename, '.pdf')
  hasInitN <- meta$initN > 0
  Strip <- function(which.panel, factor.levels, ...) {
    panel.rect(0, 0, 1, 1,
               col = ifelse(hasInitN, 'lightsteelblue2', 'gray90')[which.panel],
               border = 1)
    panel.text(x = 0.5, y = 0.5, lab = factor.levels[which.panel],
               font = ifelse(hasInitN, 2, 1)[which.panel])
  }
  pdf(filename, paper='a4', width=8, height=11)
  print(xyplot(zoo(kch), layout=layout, 
               scales=list(alternating=FALSE, tck=c(1, 0), cex=0.8, rot=0),
               ylab='Carrying capacity', strip=Strip, col=1, 
               ylim=mapply(c, 0, apply(kch, 2, max), SIMPLIFY=FALSE), 
               ...))
  dev.off()
}