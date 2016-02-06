#' Plot carrying capacity and abundance trajectories
#' 
#' Plot each population's carrying capacity and abundance over time.
#' 
#' @param meta The R object holding population info returned by \link{meta}.
#' @param kch The R object holding kch data returned by \link{kch}.
#' @param filename A character string giving the filename (with extension
#'   ".pdf") to save the plot to.
#' @param samelims (logical) If \code{TRUE}, the y-axis limits will be constant
#'   across plots.
#' @param plotN (logical) If \code{TRUE}, mean population abundance will be
#'   plotted (solid lines) in addition to carrying capacity (dashed lines).
#' @param results (required only if \code{plotN} is \code{TRUE}) The R object
#'   holding simulation results returned by \link{results}.
#' @param layout The number of columns and row of plots (default = 5 columns, 10
#'   rows).
#' @param ... Additional arguments to \link{xyplot}.
#' @return A pdf file with a plot for each population showing carrying capacity
#'   over time.
#' @importFrom zoo zoo
#' @importFrom lattice xyplot panel.rect panel.text
#' @export
knt <- function(meta, kch, filename, samelims=FALSE, plotN=FALSE, results, 
                    layout=c(5, 10), ...) {
  if (!grepl('\\.pdf$', filename)) filename <- paste0(filename, '.pdf')
  hasInitN <- meta$initN > 0
  Strip <- function(which.panel, factor.levels, ...) {
    lattice::panel.rect(0, 0, 1, 1,
               col = ifelse(hasInitN, 'lightsteelblue2', 'gray90')[which.panel],
               border = 1)
    lattice::panel.text(x = 0.5, y = 0.5, lab = factor.levels[which.panel],
               font = ifelse(hasInitN, 2, 1)[which.panel])
  }
  pdf(filename, paper='a4', width=8, height=11)
  scl <- list(alternating=FALSE, tck=c(1, 0), cex=0.8, rot=0)
  if (isTRUE(samelims)) {
    scl$y <- list(relation = "same")
  } else {
    scl$y <- list(limits=mapply(c, 0, apply(kch, 2, max), SIMPLIFY=FALSE))
  }
  if (isTRUE(plotN)) {
    kchn <- cbind(kch, results$results[, 'mean', -1]
                [, match(colnames(results$results[, 'mean', -1]), 
                         colnames(kch))])
    colnames(kchn) <- make.unique(colnames(kchn))
    print(lattice::xyplot(zoo::zoo(kchn), screens=rep(colnames(kch), 2),
                 lty=rep(c(2, 1), each=ncol(kch)),
                 layout=layout, scales=scl,
                 ylab='Carrying capacity', strip=Strip, col=1, ...))
  } else {
    print(lattice::xyplot(zoo::zoo(kch), layout=layout, scales=scl,
                 ylab='Carrying capacity', strip=Strip, col=1, ...))  
  }
  dev.off()
}
