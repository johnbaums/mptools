#' Extract Metapop population metadata
#' 
#' Extract population details from RAMAS Metapop .mp files.
#' 
#' @param mp A character string containing the path to a RAMAS Metapop .mp file.
#'   E.g. file='/path/to/metapop.mp'
#' @return A \code{data.frame} containing one row per population, with columns: 
#'   \item{popName}{The name of the population.} \item{xMetapop, yMetapop}{The spatial
#'   coordinates of the population centroid, in RAMAS's coordinate system (see
#'   \code{\link{mp2xy}}).} \item{initN}{The initial abundance.}
#'   \item{ddType}{The density dependence type.} \item{Rmax}{The maximum
#'   growth rate.} \item{K}{The initial carrying capacity.}
#'   \item{Ksd}{The standard deviation in K, if applicable.}
#'   \item{allee}{The allee parameter, if applicable.} \item{kch}{A constant, or
#'   reference to a .kch file describing temporal change in K.}
#'   \item{ddDispSourcePopN}{The parameter indicating the effect of source
#'   population abundance on its dispersal rate.} \item{cat1LocalMulti}{The
#'   local multiplier for probablity of Catastrophe 1, if applicable.}
#'   \item{cat1LocalProb}{The local probability of Catastrophe 1, if
#'   applicable.} \item{includeInTotal}{Indicates whether abundance of this 
#'   population is included in totals reported in simulation results.} 
#'   \item{stageMatrix}{The name of the stage matrix in use by the population.}
#'   \item{relFec}{The mean fecundity of this population, relative to those
#'   given in the stage matrix.} \item{relSurv}{The mean survival rates of this
#'   population, relative to those given in the stage matrix.}
#'   \item{localThr}{The abundance threshold below which the population might be
#'   considered dead (depending on global options specified elsewhere).}
#'   \item{cat2LocalMulti}{The local multiplier for probability of Catastrophe
#'   2, if applicable.} \item{cat2LocalProb}{The local probablity of Catastrophe
#'   2, if applicable.} \item{sdMatrix}{The name of the standard deviation 
#'   matrix in use.} \item{ddDispTargetPopK}{The target population K below which
#'   dispersal out of this population is reduced.} \item{tSinceCat1}{The number
#'   of time steps since this population last experienced Catastrophe 1.}
#'   \item{tSinceCat2}{The number of time steps since this population last
#'   experienced Catastrophe 2.} \item{relDisp}{Dispersal rates of this
#'   population relative to those specified by the global dispersal
#'   matrix/function.} \item{relVarFec}{Variation in fecundity rates of this
#'   population, relative to those given in the standard deviation matrix.}
#'   \item{relVarSurv}{Variation in survival rates of this population, relative
#'   to those given in the standard deviation matrix.}
#' @seealso \code{\link{results}}
#' @export
#' @examples
#' mp <- system.file('example.mp', package='mptools')
#' res <- meta(mp)
#' head(res)
meta <- function(mp) {
  if(!file.exists(mp)) stop(mp, ' doesn\'t exist.', call.=FALSE)
  message("Extracting population metadata from file:\n", mp)
  metapop <- readLines(mp)[-(1:6)]
  if (!length(grep("\\-End of file\\-", metapop[length(metapop)]))) {
    stop(sprintf("Expected final line of %s to contain \"-End of file-\"", 
                 mp))
  }
  pops <- metapop[39:(grep('^Migration$', metapop) - 1)]
  if(count.fields(textConnection(pops[1]), sep = ',') != 28)
    warning('It looks like you might have used a custom RAMAS dll.', 
            ' Only the standard set of 27 fields are returned.',
            call.=FALSE)
  pop.details <- read.csv(text = pops, stringsAsFactors = FALSE, 
                          header = FALSE)[, 1:27]
  colnames(pop.details) <- 
    c('popName', 'xMetapop', 'yMetapop', 'initN', 'ddType', 'Rmax', 'K', 'Ksd', 
      'allee', 'kch', 'ddDispSourcePopN', 'cat1LocalMulti', 'cat1LocalProb', 
      'includeInTotal', 'stageMatrix', 'relFec', 'relSurv', 'localThr', 
      'cat2LocalMulti', 'cat2LocalProb', 'sdMatrix', 'ddDispTargetPopK', 
      'tSinceCat1', 'tSinceCat2', 'relDisp', 'relVarFec', 'relVarSurv')
  pop.details
}
