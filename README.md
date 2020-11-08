
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hildar

<!-- badges: start -->

[![R build
status](https://github.com/asiripanich/hildar/workflows/R-CMD-check/badge.svg)](https://github.com/asiripanich/hildar/actions)
<!-- badges: end -->

HILDA survey data is quite large, with many columns and rows. Some waves
have more than 5000 variables. The goal of this package is to provide a
quick and easy way to quickly load HILDA data into your workspace by
converting the datasets from `.dta`, (one of the three formats HILDA
provides) to `.fst` which can be loaded much much quicker than `.dta` in
R. The main function here is `hildar::fetch()`, it can be used to load
multiple years of hilda in one call and also allows a subset of
variables to be selected. See `?fetch` for more options.

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
`options(hildar.vault = "dir_output")`, alternatively you may provide
the directory as the `.dir` argument in `fetch()`.

## Example

Here is how you can fetch HILDA data with `hildar`\!

``` r
library(hildar)

# fetch removes the HILDA year prefix from all the selected variable
# (e.g. axxx = 2001, bxxx = 2002).
fetch(years = 2001:2003, add_geography = T) %>%
  summary()
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

# add basic demographic variables
fetch(years = 2001, add_basic_vars = T) %>% 
  names()
#> [1] "xwaveid" "hhid"    "wave"    "hgage"   "hgsex"   "mrcurr"  "hhrih"  
#> [8] "hhwth"   "hhwtrp"

# hilda_dict is just a data.frame. You can `View(hilda_dict)` to quickly search
# HILDA variables without going to their documentation webpage.
head(hilda_dict)
#>        var            wave            label
#> 1: xwaveid 1,2,3,4,5,6,... XW Cross wave ID
#> 2:    hhid 1,2,3,4,5,6,...  HF Household ID
#> 3:   hhpno 1,2,3,4,5,6,... HF Person number
#> 4:   hhpid 1,2,3,4,5,6,...     HF Person ID
#> 5: hhstate 1,2,3,4,5,6,...         HF State
#> 6: hhpcode 1,2,3,4,5,6,...      HF Postcode

# the number of variables presented in each wave
hilda_dict[, unlist(wave), by = .(var, label)] %>% 
  data.table::setnames("V1", "wave") %>%
  data.table::setDT() %>%
  .[, .(number_of_variables = .N), by = wave]
#>     wave number_of_variables
#>  1:    1                4291
#>  2:    2                5222
#>  3:    3                5216
#>  4:    4                5083
#>  5:    5                5895
#>  6:    6                6142
#>  7:    7                6046
#>  8:    8                6188
#>  9:    9                6203
#> 10:   10                6482
#> 11:   11                6685
#> 12:   12                6524
#> 13:   13                6449
#> 14:   14                6713
#> 15:   15                6793
#> 16:   16                6426
```
