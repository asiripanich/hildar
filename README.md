
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hildar

<!-- badges: start -->

<!-- badges: end -->

The goal of **hildar** is to help R users that use HILDA survey data in
their works.

Please note that, this package doesn’t include any parts of the HILDA
survey data. You must be authorised to have access to a release of HILDA
survey data.

## Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("asiripanich/hildar")
```

## Import HILDA files

Basically, this package imports HILDA survey data in .dta format (STATA
format) and convert them into .fst files so they can be accessed very
quickly\!

TODO: write an instruction on how to import HILDA files.

## Example

Here is how you fetch HILDA data\!

``` r
library(hildar)

hilda_data <- fetch(years = 2001:2016, add_geography = T)

summary(hilda_data)
#>    xwaveid              hhid                wave           hgage       
#>  Length:317738      Length:317738      Min.   : 1.00   Min.   :  0.00  
#>  Class :character   Class :character   1st Qu.: 5.00   1st Qu.: 17.00  
#>  Mode  :character   Mode  :character   Median : 9.00   Median : 35.00  
#>                                        Mean   : 8.98   Mean   : 36.12  
#>                                        3rd Qu.:13.00   3rd Qu.: 53.00  
#>                                        Max.   :16.00   Max.   :101.00  
#>                                                                        
#>                             hgsex       
#>  [2] Female                    :162855  
#>  [1] Male                      :154883  
#>  [-10] Non-responding person   :     0  
#>  [-9] Non-responding household :     0  
#>  [-8] No SCQ                   :     0  
#>  [-7] Not able to be determined:     0  
#>  (Other)                       :     0  
#>                                 mrcurr                            hhrih      
#>  [1] Legally married               :113430   [4] Couple wo child     :73750  
#>  [-10] Non-responding person       : 82127   [8] Child < 15          :67554  
#>  [6] Never married and not de facto: 56987   [1] Couple w child < 15 :58296  
#>  [2] De facto                      : 32708   [12] Lone person        :37536  
#>  [4] Divorced                      : 14078   [10] Non-dependent child:17388  
#>  [5] Widowed                       : 11885   [9] Dependent student   :17005  
#>  (Other)                           :  6523   (Other)                 :46209  
#>                     hhsgcc          hhwth             hhwtrp       
#>  [11] Greater Sydney   :54716   Min.   :    0.0   Min.   :  -10.0  
#>  [21] Greater Melbourne:54419   1st Qu.:  669.6   1st Qu.:  -10.0  
#>  [19] Rest of NSW      :42028   Median :  896.3   Median :  778.2  
#>  [39] Rest of Qld      :36260   Mean   : 1060.3   Mean   :  849.9  
#>  [31] Greater Brisbane :30206   3rd Qu.: 1212.9   3rd Qu.: 1146.0  
#>  [29] Rest of Vic.     :23801   Max.   :20000.0   Max.   :22000.0  
#>  (Other)               :76308
```
