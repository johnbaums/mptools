## Test environments
* local windows 8.1, R 3.2.3 and devel
* win-builder R 3.2.3 and devel
* ubuntu 14.04 (on travis-ci), R 3.2.3 and devel

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE (win-builder):

* checking CRAN incoming feasibility ... NOTE

    Maintainer: 'John Baumgartner <johnbaums@gmail.com>'

    New submission

    Possibly mis-spelled words in DESCRIPTION:
      GIS (10:38)
      Metapop (4:14, 5:20)
      RAMAS (4:8, 5:14, 8:40) 
    
**Response:** Words in DESCRIPTION are spelled accurately.


## Examples

One of the examples is considerably slower than maximum time desired by CRAN: 

    * checking examples ...
    ** running examples for arch 'i386' ... [23s] OK
    Examples with CPU or elapsed time > 5s
               user system elapsed
    mp_animate 7.08   0.45   15.65
    ** running examples for arch 'x64' ... [24s] OK
    Examples with CPU or elapsed time > 5s
               user system elapsed
    mp_animate 7.88   0.48   16.21
    
**Response:** On my local system, R 3.2.3 and R devel report < 8 sec for this
example. I feel that the example is a valuable component of the documentation.
It uses `animation::saveGIF`, and while I've already slimmed the example down
considerably (to 20 frames), the process is time-consuming. If requested by
CRAN, I will remove the example and refer to the vignette.

## What is an .mp file?

In response to a previous submission of this package, I was asked to include 
information (and web link) describing RAMAS Metapop .mp files. Unfortunately 
documentation is scarce (RAMAS software is not FOSS and the manual is not free),
but I have included @references linking to RAMAS webpages, and have described
.mp files under `@param mp` at `?results` and `?meta`. I also provide a vignette. 
I envisage that this package will only be used by people familiar with 
RAMAS Metapop Such people will also be familiar with the .mp format.

## Downstream dependencies
This package currently has no downstream dependencies
