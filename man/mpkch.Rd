\name{mpkch}
\alias{mpkch}
\title{Extract Metapop KCH}
\usage{
mpkch(meta, path)
}
\arguments{
  \item{meta}{The R object holding Metapop metadata
  returned by \link{mpmeta}.}
  \item{path}{A character string giving the full path to
  the directory containing .kch files referred to in object
  \code{meta}.}
}
\value{
A \code{matrix} containing one column per population,
giving the carrying capacity at each time step (i.e. each
row).
}
\description{
Extract KCH time series for each RAMAS Metapop population.
}