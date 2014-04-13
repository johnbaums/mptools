#' Extract simulation results from RAMAS Metapop .mp files
#' 
#' Extracts population size simulation results (mean, sd, min and max),
#' including expected minimum abundance (EMA) and its standard deviation, from a
#' RAMAS Metapop .mp file.
#' 
#' @param mp A character string containing the path to a RAMAS Metapop .mp file 
#'   containing simulation results. E.g. file='/path/to/metapop.mp'
#' @return A \code{list} containing: \item{results}{An array containing 
#'   simulation results extracted from \code{file}. The number of rows is equal 
#'   to the number of time steps in the simulation. The array has four columns, 
#'   containing mean, sd, min and max of population size across iterations at 
#'   each time step (i.e. each row), and the number of array slices is equal to 
#'   the number of populations. The third dimension is named according to 
#'   population names (numeric component only).} \item{minmaxterm}{A matrix 
#'   containing the minimum and maximum (across years), and terminal occupancy 
#'   for each iteration.} \item{EMA}{The mean minimum abundance (i.e. the mean, 
#'   across iterations, of the minimum abundance for each simulation 
#'   trajectory).} \item{SDMA}{The standard deviation of minimum abundance (i.e.
#'   the sd, across iterations, of the minimum abundance for each simulation 
#'   trajectory).} \item{timestamp}{A POSIXlt object representing the date and 
#'   time at which the simulation was completed.} \item{iters}{The number of 
#'   iterations performed.}
#' @seealso \code{\link{mpmeta}}
#' @note This has been tested for RAMAS version 5.1, and may produce unexpected 
#'   results for other versions.
#' @export
#' @examples 
#' f <- system.file('litspe.mp', package='mptools')
#' res <- mpresults(f)
#' str(res)
#' 
#' # look at the simulation results for the first array slice (NB: this slice is
#' all pops combined):
#' res$results[,, 1]
#' # equivalently, subset by name:
#' res$results[,, 'ALL']
#' res$results[,, 'Pop 190']
#' res$results[,, '240A24']
#' dimnames(res$results)[[3]] # population names
#' 
#' # return a matrix of mean population sizes, where columns represent
#' populations and rows are time steps:
#' res$results[, 1, ] # or res$results[, 'mean', ]
#' 
#' # sd across iterations:
#' res$results[, 2, ] # or res$results[, 'sd', ]
#' 
#' # min pop sizes across iterations:
#' res$results[, 3, ] # or res$results[, 'min', ]
#' 
#' # max pop sizes across iterations:
#' res$results[, 4, ] # or res$results[, 'max', ] 
mpresults <-
function(mp) {
  message(sprintf('Extracting simulation results from file %s...', mp))
  metapop <- readLines(mp)[-1]
  if(!length(grep('Simulation results', metapop))) {
    stop(sprintf('There are no simulation results in %s.', mp), call.=FALSE)
  }
  if(!length(grep('\\-End of file\\-', metapop[length(metapop)]))) {
    stop(sprintf('Expected final line of %s to contain "-End of file-"', mp))
  }
  pops <- metapop[(grep(28, count.fields(mp, sep=',', blank.lines.skip=FALSE))[1]-1):(grep('^Migration', metapop)[1]-1)]
  pop.details <- read.csv(text=pops, stringsAsFactors=FALSE, header=FALSE)
  pop.details <- pop.details[,-(ncol(pop.details))]
  colnames(pop.details) <- c('popName', 'xMetapop', 'yMetapop', 'initN',
    'ddType', 'Rmax', 'K', 'Ksd', 'allee', 'kch', 'ddDispSourcePopN',
    'cat1LocalMulti', 'cat1LocatProb', 'includeInTotal', 'stageMatrix', 'relFec',
    'relSurv', 'localThr', 'cat2LocalMulti', 'cat2LocatProb', 'sdMatrix',
    'ddDispTargetPopK', 'tSinceCat1', 'tSinceCat2', 'relDisp', 'relVarFec',
    'relVarSurv')
  sim.res <- metapop[grep('^Simulation results', 
                          metapop):(grep('^Occupancy', metapop)-1)]
  res <- strsplit(sim.res[-(1:3)], ' ') 
  pop.ind <- grep('Pop', res)  
  res <- do.call(rbind, res[-pop.ind])
  res <- apply(res, 2, as.numeric)
  res.t <- t(res)
  dim(res.t) <- c(4, diff(pop.ind)[1]-1, nrow(res)/(diff(pop.ind)[1]-1))
  res <- aperm(res.t, c(2, 1, 3))
  dimnames(res) <- list(NULL, 
                        c('mean', 'sd', 'min', 'max'),
                        c('ALL', pop.details$popName))
  minmaxterm <- metapop[grep('^Min.  Max.  Ter.$', 
                             metapop):(grep('Time to cross', metapop)-1)]
  minmaxterm <- strsplit(minmaxterm[-1], ' ')
  minmaxterm <- apply(do.call(rbind, minmaxterm), 2, as.numeric)
  if(nrow(pop.details)==1) dim(minmaxterm) <- c(1, 3)
  colnames(minmaxterm) <- c('min', 'max', 'terminal')
  EMA <- mean(minmaxterm[, 'min'])
  SDMA <- sd(minmaxterm[, 'min'])
  list(results=res, minmaxterm=minmaxterm, EMA=EMA, SDMA=SDMA,
       timestamp=as.POSIXlt(sim.res[1], format="Simulation results %d/%m/%Y %X"), 
       iters=as.numeric(sub('(\\d*).*', '\\1', sim.res[2])))
}