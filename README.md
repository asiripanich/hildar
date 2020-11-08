
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hildar

<!-- badges: start -->

[![R build
status](https://github.com/asiripanich/hildar/workflows/R-CMD-check/badge.svg)](https://github.com/asiripanich/hildar/actions)
<!-- badges: end -->

The goal of **hildar** is to help R users that use HILDA survey data in
their works.

Please note that, this package doesn’t include any parts of the HILDA
survey data. You must be authorised to have access to a release of HILDA
survey data.

## 1\) Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("asiripanich/hildar")
```

## 2\) Store HILDA files as fst

Use `setup_hildar(dir_input = "/path/to/your/hilda-stata-files",
dir_output = "/path/to/save/hilda-fst-files")` to read in HILDA STATA
(.dta) files and save them as `.fst` files for `hildar`. `.fst` is a
binary data format that can be read very quickly, a lot faster than
`.dta`.

## 3\) Set `hildar.vault` R option

Let hildar knows where your `dir_output` is by setting
options(hildar.vault = “dir\_output”), alternatively you may provide the
.dir argument in `fetch()`.

## Example

Here is how you fetch HILDA data\!

``` r
library(hildar)
hilda_data <- fetch(years = 2001:2003, add_geography = T)
summary(hilda_data)
#>    xwaveid              hhid                wave          hgage       
#>  Length:55899       Length:55899       Min.   :1.00   Min.   :  0.00  
#>  Class :character   Class :character   1st Qu.:1.00   1st Qu.: 15.00  
#>  Mode  :character   Mode  :character   Median :2.00   Median : 34.00  
#>                                        Mean   :1.96   Mean   : 34.81  
#>                                        3rd Qu.:3.00   3rd Qu.: 51.00  
#>                                        Max.   :3.00   Max.   :100.00  
#>     hgsex              mrcurr             hhrih              hhsgcc         
#>  Length:55899       Length:55899       Length:55899       Length:55899      
#>  Class :character   Class :character   Class :character   Class :character  
#>  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
#>                                                                             
#>                                                                             
#>                                                                             
#>      hhwth             hhwtrp       
#>  Min.   :    0.0   Min.   :  -10.0  
#>  1st Qu.:  734.1   1st Qu.:  -10.0  
#>  Median :  917.2   Median :  824.0  
#>  Mean   : 1021.9   Mean   :  809.4  
#>  3rd Qu.: 1162.6   3rd Qu.: 1129.6  
#>  Max.   :13878.4   Max.   :16000.0
```
