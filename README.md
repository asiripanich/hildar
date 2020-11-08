
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hildar

<!-- badges: start -->

[![R build
status](https://github.com/asiripanich/hildar/workflows/R-CMD-check/badge.svg)](https://github.com/asiripanich/hildar/actions)
<!-- badges: end -->

[HILDA survey data](https://melbourneinstitute.unimelb.edu.au/hilda) is
quite large, with many columns and rows. Some waves have more than 5000
variables. The goal of this package is to provide a quick and easy way
to quickly load HILDA data into your workspace by converting the
datasets from `.dta`, (one of the three formats HILDA provides) to
`.fst` which can be loaded much much quicker than `.dta` in R. The main
function here is `hildar::fetch()`, it can be used to load multiple
years of hilda in one call and also allows a subset of variables to be
selected. See `?fetch` for more options.

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
```

There is a quick option to add basic demographic variables to the data,
which is set to TRUE by default.

``` r
fetch(years = 2001, add_basic_vars = T) %>% 
  names()
#> [1] "xwaveid" "hhid"    "wave"    "hgage"   "hgsex"   "mrcurr"  "hhrih"  
#> [8] "hhwth"   "hhwtrp"
```

How about doing a quick search to find variables that you want? Use
`hilda_dict` which is a data.table that you can search or view HILDA
variables without going to their documentation webpage.

``` r
head(hilda_dict)
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
emp_vars = hilda_dict[grepl(pattern = "employment", label), var]
emp_vars
#>   [1] "hhura"   "fmfempo" "fmmempo" "esempst" "ujljcnt" "jbmind"  "jbempst"
#>   [8] "jbmlh"   "molha"   "molmth"  "molyr"   "mol3rd"  "losateo" "loimpew"
#>  [15] "jbmi06"  "es"      "esempdt" "molt"    "fmfemp"  "fmmemp"  "lshrcom"
#>  [22] "cnpu_fd" "cnpu_np" "cnpu_o1" "cnpu_o2" "cnpu_na" "cnph_o1" "cnph_o2"
#>  [29] "cnpc_ps" "cnpc_fd" "cnpc_o1" "cnpc_o2" "cnsu_ps" "cnsu_fd" "cnsu_kp"
#>  [36] "cnsu_np" "cnsu_o1" "cnsu_o2" "cnsu_na" "cnsh_bs" "cnsh_ru" "cnsh_re"
#>  [43] "cnsh_ps" "cnsh_fd" "cnsh_kp" "cnsh_o1" "cnsh_o2" "cnsc_bs" "cnsc_ru"
#>  [50] "cnsc_ps" "cnsc_fd" "cnsc_kp" "cnsc_o1" "cnsc_o2" "chkb12"  "pjothru"
#>  [57] "pjothra" "pjotcnt" "fmfempn" "fmmempn" "lshremp" "lsmnemp" "lsmncom"
#>  [64] "fisemr"  "lsemp"   "lscom"   "jbtremp" "ujtros"  "ncesop"  "rcesop" 
#>  [71] "rtgwage" "hepuwrk" "herjob"  "herhour" "hechjob" "hetowrk" "heonas" 
#>  [78] "hespeq"  "heothed" "nsu1_fd" "nsu1_o1" "nsu1_o2" "nsu1_na" "nsu1_np"
#>  [85] "nsu2_fd" "nsu2_o1" "nsu2_o2" "nsu2_na" "nsu2_np" "nsu3_fd" "nsu3_o1"
#>  [92] "nsu3_o2" "nsu3_na" "nsu3_np" "nsu4_fd" "nsu4_o1" "nsu4_o2" "nsu4_na"
#>  [99] "nsu4_np" "nsu5_fd" "nsu5_o1" "nsu5_o2" "nsu5_na" "nsu5_np" "nsu6_fd"
#> [106] "nsu6_o1" "nsu6_o2" "nsu6_na" "nsu6_np" "nsh1_ps" "nsh2_ps" "nsh3_ps"
#> [113] "nsh4_ps" "nsh5_ps" "nsh6_ps" "nsh1_fd" "nsh2_fd" "nsh3_fd" "nsh4_fd"
#> [120] "nsh5_fd" "nsh6_fd" "nsh1_o1" "nsh2_o1" "nsh3_o1" "nsh4_o1" "nsh5_o1"
#> [127] "nsh6_o1" "nsh1_o2" "nsh2_o2" "nsh3_o2" "nsh4_o2" "nsh5_o2" "nsh6_o2"
#> [134] "npu1_o1" "npu1_o2" "npu1_na" "npu1_np" "npu2_o1" "npu2_o2" "npu2_na"
#> [141] "npu2_np" "npu3_o1" "npu3_o2" "npu3_na" "npu3_np" "npu4_o1" "npu4_o2"
#> [148] "npu4_na" "npu4_np" "npu5_o1" "npu5_o2" "npu5_na" "npu5_np" "npu6_o1"
#> [155] "npu6_o2" "npu6_na" "npu6_np" "nph1_fd" "nph2_fd" "nph3_fd" "nph4_fd"
#> [162] "nph5_fd" "nph6_fd" "nph1_o1" "nph2_o1" "nph3_o1" "nph4_o1" "nph5_o1"
#> [169] "nph6_o1" "nph1_o2" "nph2_o2" "nph3_o2" "nph4_o2" "nph5_o2" "nph6_o2"
#> [176] "nrpmact" "jttpewt" "jttpeot" "jdemp"   "skces2"  "heothrf" "heothdk"
#> [183] "chb12"   "lfpe01"  "lfpe02"  "lfpe03"  "lfpe04"  "lfpe05"  "lfpe06" 
#> [190] "lfpe07"  "lfpe08"  "lfpe09"  "lfpe10"  "lfpe11"  "lfpe12"  "lfpe13" 
#> [197] "lfpe14"  "lfpe15"
hilda_data = fetch(years = 2001:2003, vars = emp_vars)
dim(hilda_data)
#> [1] 55899    80
```

Here is a summary of the dimensions of our HILDA data files.

``` r
# the number of variables and rows in each wave
nrows_by_wave = 
  fetch(years = 2001:2016, add_basic_vars = F) %>%
  .[, .(number_of_rows = .N), by = wave]

hilda_dict[, unlist(wave), by = .(var, label)] %>% 
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
