## Test environments
* local windows install, R 3.2.3 and devel
* ubuntu 12.04 (on travis-ci), R 3.2.3

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* checking CRAN incoming feasibility ... NOTE

    Maintainer: 'John Baumgartner <johnbaums@gmail.com>'

    New submission

    Possibly mis-spelled words in DESCRIPTION:
      Metapop (3:14, 11:5)
      RAMAS (3:8, 10:71)
      metadata (10:34)
      
    Words in DESCRIPTION are not mis-spelled.

---

The development version of R additionally notes that:

* Version contains large components (0.5.0)

    The package contains example data that are slightly over 3 MB. This is 
    typical of RAMAS Metapop data.

## Downstream dependencies
This package currently has no downstream dependencies
