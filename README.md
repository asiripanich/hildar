
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hildar

<!-- badges: start -->

[![R-CMD-check](https://github.com/asiripanich/hildar/workflows/R-CMD-check/badge.svg)](https://github.com/asiripanich/hildar/actions)
<!-- badges: end -->

![](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLV9hgux5t_pK-anbgugJ8GfoMxjD6D7_nHA&usqp=CAU)

(source:
<https://www.dss.gov.au/about-the-department/national-centre-for-longitudinal-data>)

[HILDA survey data](https://melbourneinstitute.unimelb.edu.au/hilda) is
a large panel survey with close to 20 waves (2001 - 2020). Some waves
have more than 5000 variables. The goal of this package is to provide a
quick and easy way to quickly query HILDA data into your R workspace.
This is possible by converting the dataset of each wave from `.dta`, one
of the three formats HILDA provides, to `fst` format.
`[fst](https://github.com/fstpackage/fst)` is a binary format and can be
read much much quicker than `.dta` in R. The main function that `hildar`
provides is `hil_fetch()`. It can load multiple waves of HILDA in one
call and also allows the user to select a subset of variables instead of
loading everything. See `?hil_fetch` for more options.

## 1) Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("asiripanich/hildar")
```

## 2) Store HILDA files as fst

Use `hil_setup()` to read HILDA STATA (.dta) files and save them as
`.fst` files. `.fst` is a binary data format that can be read very
quickly, a lot faster than `.dta`.

``` r
hil_setup(dir_input = "/path/to/your/hilda-stata-files", dir_output = "/path/to/save/hilda-fst-files")
```

This will allow you to fast query the data across all waves using
`hil_fetch()`.

## 3) Set `HILDA_FST` as a global option or an R environment variable.

`hil_fetch()` requires the user to tell it where the HILDA fst files
generated in the previous step are stored. You can either set this
`HILDA_FST` as a global option or an R environment variable. Setting
this as a persistent option for all your R sessions will make
`hil_fetch()` more convinient to use. Alternatively, you can manually
set it in each call using `hilda_fst_dir` argument in `hil_fetch()`.

## Example

Here is how you can fetch HILDA data with `hildar`!

``` r
library(hildar)

# fetch removes the HILDA year prefix from all the selected variable
# (e.g. axxx = 2001, bxxx = 2002).
hil_fetch(years = 2001:2003, add_geography = T) %>%
  summary()
#>    xwaveid              hhid                wave     
#>  Length:55899       Length:55899       Min.   :1.00  
#>  Class :character   Class :character   1st Qu.:1.00  
#>  Mode  :character   Mode  :character   Median :2.00  
#>                                        Mean   :1.96  
#>                                        3rd Qu.:3.00  
#>                                        Max.   :3.00  
#>      hgage           hgsex              mrcurr         
#>  Min.   :  0.00   Length:55899       Length:55899      
#>  1st Qu.: 15.00   Class :character   Class :character  
#>  Median : 34.00   Mode  :character   Mode  :character  
#>  Mean   : 34.81                                        
#>  3rd Qu.: 51.00                                        
#>  Max.   :100.00                                        
#>     hhrih              hhsgcc              hhwth        
#>  Length:55899       Length:55899       Min.   :    0.0  
#>  Class :character   Class :character   1st Qu.:  734.1  
#>  Mode  :character   Mode  :character   Median :  917.2  
#>                                        Mean   : 1021.9  
#>                                        3rd Qu.: 1162.6  
#>                                        Max.   :13878.4  
#>      hhwtrp       
#>  Min.   :  -10.0  
#>  1st Qu.:  -10.0  
#>  Median :  824.0  
#>  Mean   :  809.4  
#>  3rd Qu.: 1129.6  
#>  Max.   :16000.0
```

There is a quick option to add basic demographic variables to the data,
which is set to TRUE by default.

``` r
hil_fetch(years = 2001, add_basic_vars = T) %>%
  names()
#> [1] "xwaveid" "hhid"    "wave"    "hgage"   "hgsex"   "mrcurr" 
#> [7] "hhrih"   "hhwth"   "hhwtrp"
```

How about doing a quick search to find variables that you want? Use
`hil_dict` which is a data.table that you can search or view HILDA
variables without going to their documentation webpage.

``` r
head(hil_dict)
#>        var            wave            label
#> 1: xwaveid 1,2,3,4,5,6,... XW Cross wave ID
#> 2:    hhid 1,2,3,4,5,6,...  HF Household ID
#> 3:   hhpno 1,2,3,4,5,6,... HF Person number
#> 4:   hhpid 1,2,3,4,5,6,...     HF Person ID
#> 5: hhstate 1,2,3,4,5,6,...         HF State
#> 6: hhpcode 1,2,3,4,5,6,...      HF Postcode
```

Let say we want to select all variables that are related to ‘employment’
we can easily incorporate them into the `fetch()` function.

``` r
emp_vars <- hil_dict[grepl(pattern = "employment", label), var]
emp_vars
#>   [1] "hhura"   "fmfempo" "fmmempo" "esempst" "ujljcnt" "jbmind" 
#>   [7] "jbempst" "jbmlh"   "molha"   "molmth"  "molyr"   "mol3rd" 
#>  [13] "losateo" "loimpew" "jbmi06"  "es"      "esempdt" "molt"   
#>  [19] "fmfemp"  "fmmemp"  "lshrcom" "cnpu_fd" "cnpu_np" "cnpu_o1"
#>  [25] "cnpu_o2" "cnpu_na" "cnph_o1" "cnph_o2" "cnpc_ps" "cnpc_fd"
#>  [31] "cnpc_o1" "cnpc_o2" "cnsu_ps" "cnsu_fd" "cnsu_kp" "cnsu_np"
#>  [37] "cnsu_o1" "cnsu_o2" "cnsu_na" "cnsh_bs" "cnsh_ru" "cnsh_re"
#>  [43] "cnsh_ps" "cnsh_fd" "cnsh_kp" "cnsh_o1" "cnsh_o2" "cnsc_bs"
#>  [49] "cnsc_ru" "cnsc_ps" "cnsc_fd" "cnsc_kp" "cnsc_o1" "cnsc_o2"
#>  [55] "chkb12"  "pjothru" "pjothra" "pjotcnt" "fmfempn" "fmmempn"
#>  [61] "lshremp" "lsmnemp" "lsmncom" "fisemr"  "lsemp"   "lscom"  
#>  [67] "jbtremp" "ujtros"  "ncesop"  "rcesop"  "rtgwage" "hepuwrk"
#>  [73] "herjob"  "herhour" "hechjob" "hetowrk" "heonas"  "hespeq" 
#>  [79] "heothed" "nsu1_fd" "nsu1_o1" "nsu1_o2" "nsu1_na" "nsu1_np"
#>  [85] "nsu2_fd" "nsu2_o1" "nsu2_o2" "nsu2_na" "nsu2_np" "nsu3_fd"
#>  [91] "nsu3_o1" "nsu3_o2" "nsu3_na" "nsu3_np" "nsu4_fd" "nsu4_o1"
#>  [97] "nsu4_o2" "nsu4_na" "nsu4_np" "nsu5_fd" "nsu5_o1" "nsu5_o2"
#> [103] "nsu5_na" "nsu5_np" "nsu6_fd" "nsu6_o1" "nsu6_o2" "nsu6_na"
#> [109] "nsu6_np" "nsh1_ps" "nsh2_ps" "nsh3_ps" "nsh4_ps" "nsh5_ps"
#> [115] "nsh6_ps" "nsh1_fd" "nsh2_fd" "nsh3_fd" "nsh4_fd" "nsh5_fd"
#> [121] "nsh6_fd" "nsh1_o1" "nsh2_o1" "nsh3_o1" "nsh4_o1" "nsh5_o1"
#> [127] "nsh6_o1" "nsh1_o2" "nsh2_o2" "nsh3_o2" "nsh4_o2" "nsh5_o2"
#> [133] "nsh6_o2" "npu1_o1" "npu1_o2" "npu1_na" "npu1_np" "npu2_o1"
#> [139] "npu2_o2" "npu2_na" "npu2_np" "npu3_o1" "npu3_o2" "npu3_na"
#> [145] "npu3_np" "npu4_o1" "npu4_o2" "npu4_na" "npu4_np" "npu5_o1"
#> [151] "npu5_o2" "npu5_na" "npu5_np" "npu6_o1" "npu6_o2" "npu6_na"
#> [157] "npu6_np" "nph1_fd" "nph2_fd" "nph3_fd" "nph4_fd" "nph5_fd"
#> [163] "nph6_fd" "nph1_o1" "nph2_o1" "nph3_o1" "nph4_o1" "nph5_o1"
#> [169] "nph6_o1" "nph1_o2" "nph2_o2" "nph3_o2" "nph4_o2" "nph5_o2"
#> [175] "nph6_o2" "nrpmact" "jttpewt" "jttpeot" "jdemp"   "skces2" 
#> [181] "heothrf" "heothdk" "chb12"   "lfpe01"  "lfpe02"  "lfpe03" 
#> [187] "lfpe04"  "lfpe05"  "lfpe06"  "lfpe07"  "lfpe08"  "lfpe09" 
#> [193] "lfpe10"  "lfpe11"  "lfpe12"  "lfpe13"  "lfpe14"  "lfpe15"
hilda_data <- hil_fetch(years = 2001:2003, vars = emp_vars)
dim(hilda_data)
#> [1] 55899    80
```

Here is a summary of the dimensions of our HILDA data files.

``` r
# the number of variables and rows in each wave
nrows_by_wave <-
  hil_fetch(years = 2001:2016, add_basic_vars = F) %>%
  .[, .(number_of_rows = .N), by = wave]

hil_dict[, unlist(wave), by = .(var, label)] %>%
  data.table::setnames("V1", "wave") %>%
  data.table::setDT() %>%
  .[, .(number_of_variables = .N), by = wave] %>%
  merge(nrows_by_wave, by = "wave")
#>     wave number_of_variables number_of_rows
#>  1:    1                4291          19914
#>  2:    2                5222          18295
#>  3:    3                5216          17690
#>  4:    4                5083          17209
#>  5:    5                5895          17467
#>  6:    6                6142          17453
#>  7:    7                6046          17280
#>  8:    8                6188          17144
#>  9:    9                6203          17632
#> 10:   10                6482          17855
#> 11:   11                6685          23415
#> 12:   12                6524          23182
#> 13:   13                6449          23299
#> 14:   14                6713          23110
#> 15:   15                6793          23297
#> 16:   16                6426          23496
```
