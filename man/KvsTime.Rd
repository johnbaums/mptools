\name{KvsTime}
\alias{KvsTime}
\title{Plot carrying capacity vs time}
\usage{
KvsTime(meta, kch, filename, samelims = FALSE, plotN = FALSE, results,
  layout = c(5, 10), ...)
}
\arguments{
  \item{meta}{The R object holding population info returned
  by \link{mpmeta}.}

  \item{kch}{The R object holding kch data returned by
  \link{mpkch}.}

  \item{filename}{A character string giving the filename
  (with extension ".pdf") to save the plot to.}

  \item{samelims}{(logical) If \code{TRUE}, the y-axis
  limits will be constant across plots.}

  \item{plotN}{(logical) If \code{TRUE}, mean population
  abundance will be plotted (solid lines) in addition to
  carrying capacity (dashed lines).}

  \item{results}{(required only if \code{plotN} is
  \code{TRUE}) The R object holding simulation results
  returned by \link{mpresults}.}

  \item{layout}{The number of columns and row of plots
  (default = 5 columns, 10 rows).}

  \item{...}{Additional arguments to \link{xyplot.zoo}.}
}
\value{
A pdf file with a plot for each population showing carrying
capacity over time.
}
\description{
Plot each population's carrying capacity vs time.
}