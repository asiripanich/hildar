
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hildar

<!-- badges: start -->

[![R-CMD-check](https://github.com/asiripanich/hildar/workflows/R-CMD-check/badge.svg)](https://github.com/asiripanich/hildar/actions)

<!-- badges: end -->
<p align="center">
<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLV9hgux5t_pK-anbgugJ8GfoMxjD6D7_nHA&amp;usqp=CAU" title="source: https://www.dss.gov.au/about-the-department/national-centre-for-longitudinal-data" width="400"/>
</p>

**source:
<https://www.dss.gov.au/about-the-department/national-centre-for-longitudinal-data>**

[HILDA survey data](https://melbourneinstitute.unimelb.edu.au/hilda) is
a large panel survey with close to 20 waves (2001 - 2020), and some
waves have more than 5000 variables, which makes reading them into R a
little challenging.

The goal of this package is to provide a quick and easy way to query
HILDA data into R. This is possible by converting each wave of HILDA
from its STATA file (`.dta`), one of the three formats HILDA provides,
to `fst` format. `[fst](https://github.com/fstpackage/fst)` is a binary
format and can be read much much quicker than `.dta` in R.

| Function name | Description                                                                                                                                                                               |
|---------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `hil_setup()` | Setup HILDA fst files for `hil_fetch() to use`.                                                                                                                                           |
| `hil_fetch()` | Fetches HILDA records based on query options.                                                                                                                                             |
| `hil_dict`    | Shows HILDA data glossary and waves each variable is available in. This provides a convenient way to select multiple variables based on their description by passing it to `hil_fetch()`. |

> Note that, `hil_dict` is a data.frame object bundled with the package,
> and was generated using HILDA 2001 - 2016. Hence, it only covers
> variables from those 16 waves. In a future release, `hilar` will
> create `hil_dict` that matches your HILDA data during `hil_setup()`.

## 1) Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("asiripanich/hildar")
```

## 2) Store HILDA as `.fst` files

Use `hil_setup()` to read HILDA STATA (.dta) files and save them as
`.fst` files. `.fst` is a binary data format that can be read very
quickly, a lot faster than `.dta`.

``` r
hil_setup(dir_input = "/path/to/your/hilda-stata-files", dir_output = "/path/to/save/hilda-fst-files")
```

This will allow you to fast query the data across all waves using
`hil_fetch()`.

## 3) Tell `hildar` where the `.fst` files are stored.

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
#>    xwaveid              hhid                wave          hgage           hgsex              mrcurr             hhrih              hhsgcc              hhwth             hhwtrp       
#>  Length:55899       Length:55899       Min.   :1.00   Min.   :  0.00   Length:55899       Length:55899       Length:55899       Length:55899       Min.   :    0.0   Min.   :  -10.0  
#>  Class :character   Class :character   1st Qu.:1.00   1st Qu.: 15.00   Class :character   Class :character   Class :character   Class :character   1st Qu.:  732.7   1st Qu.:  -10.0  
#>  Mode  :character   Mode  :character   Median :2.00   Median : 34.00   Mode  :character   Mode  :character   Mode  :character   Mode  :character   Median :  909.4   Median :  821.9  
#>                                        Mean   :1.96   Mean   : 34.82                                                                               Mean   : 1021.9   Mean   :  809.4  
#>                                        3rd Qu.:3.00   3rd Qu.: 51.00                                                                               3rd Qu.: 1148.8   3rd Qu.: 1122.0  
#>                                        Max.   :3.00   Max.   :100.00                                                                               Max.   :14094.0   Max.   :16000.0
```

There is a quick option to add basic demographic variables to the data,
which is set to TRUE by default.

``` r
hil_fetch(years = 2001, add_basic_vars = T) %>%
  names()
#> [1] "xwaveid" "hhid"    "wave"    "hgage"   "hgsex"   "mrcurr"  "hhrih"   "hhwth"   "hhwtrp"
```

How about doing a quick search to find variables that you want? Use
`hil_dict` which is a data.table that you can search or view HILDA
variables without going to their documentation webpage.

``` r
hilda_dictionary <- hil_dict()
```

Let say we want to select all variables that are related to
‘employment’. Here is how we can easily use the selected employment
variables in `hil_fetch()`.

``` r
emp_vars <- hilda_dictionary[grepl(pattern = "employment", label), var]
emp_vars
#>   [1] "hhura"   "fmfempo" "fmmempo" "esempst" "ujljcnt" "jbmind"  "jbempst" "jbmlh"   "molha"   "molmth"  "molyr"   "mol3rd"  "losateo" "loimpew" "jbmi06"  "es"      "esempdt" "fmfemp"  "fmmemp"  "lshrcom" "cnpu_fd" "cnpu_np" "cnpu_o1" "cnpu_o2" "cnpu_na" "cnph_o1"
#>  [27] "cnph_o2" "cnpc_ps" "cnpc_fd" "cnpc_o1" "cnpc_o2" "cnsu_ps" "cnsu_fd" "cnsu_kp" "cnsu_np" "cnsu_o1" "cnsu_o2" "cnsu_na" "cnsh_bs" "cnsh_ru" "cnsh_re" "cnsh_ps" "cnsh_fd" "cnsh_kp" "cnsh_o1" "cnsh_o2" "cnsc_bs" "cnsc_ru" "cnsc_ps" "cnsc_fd" "cnsc_kp" "cnsc_o1"
#>  [53] "cnsc_o2" "chkb12"  "pjothru" "pjothra" "pjotcnt" "fmfempn" "fmmempn" "lshremp" "lsmnemp" "lsmncom" "fisemr"  "lsemp"   "lscom"   "jbtremp" "ujtros"  "ncesop"  "rcesop"  "rtgwage" "cnsh_au" "hepuwrk" "herjob"  "herhour" "hechjob" "hetowrk" "heonas"  "hespeq" 
#>  [79] "heothed" "nsu1_fd" "nsu1_o1" "nsu1_o2" "nsu1_na" "nsu1_np" "nsu2_fd" "nsu2_o1" "nsu2_o2" "nsu2_na" "nsu2_np" "nsu3_fd" "nsu3_o1" "nsu3_o2" "nsu3_na" "nsu3_np" "nsu4_fd" "nsu4_o1" "nsu4_o2" "nsu4_na" "nsu4_np" "nsu5_fd" "nsu5_o1" "nsu5_o2" "nsu5_na" "nsu5_np"
#> [105] "nsu6_fd" "nsu6_o1" "nsu6_o2" "nsu6_na" "nsu6_np" "nsh1_ps" "nsh2_ps" "nsh3_ps" "nsh4_ps" "nsh5_ps" "nsh6_ps" "nsh1_fd" "nsh2_fd" "nsh3_fd" "nsh4_fd" "nsh5_fd" "nsh6_fd" "nsh1_o1" "nsh2_o1" "nsh3_o1" "nsh4_o1" "nsh5_o1" "nsh6_o1" "nsh1_o2" "nsh2_o2" "nsh3_o2"
#> [131] "nsh4_o2" "nsh5_o2" "nsh6_o2" "npu1_o1" "npu1_o2" "npu1_na" "npu1_np" "npu2_o1" "npu2_o2" "npu2_na" "npu2_np" "npu3_o1" "npu3_o2" "npu3_na" "npu3_np" "npu4_o1" "npu4_o2" "npu4_na" "npu4_np" "npu5_o1" "npu5_o2" "npu5_na" "npu5_np" "npu6_o1" "npu6_o2" "npu6_na"
#> [157] "npu6_np" "nph1_fd" "nph2_fd" "nph3_fd" "nph4_fd" "nph5_fd" "nph6_fd" "nph1_o1" "nph2_o1" "nph3_o1" "nph4_o1" "nph5_o1" "nph6_o1" "nph1_o2" "nph2_o2" "nph3_o2" "nph4_o2" "nph5_o2" "nph6_o2" "nrpmact" "jttpewt" "jttpeot" "jdemp"   "skces2"  "heothrf" "heothdk"
#> [183] "chb12"   "lfpe01"  "lfpe02"  "lfpe03"  "lfpe04"  "lfpe05"  "lfpe06"  "lfpe07"  "lfpe08"  "lfpe09"  "lfpe10"  "lfpe11"  "lfpe12"  "lfpe13"  "lfpe14"  "lfpe15"  "lfpe16"  "lfpe17"  "lfpe18"  "lfpe19"  "cvpw"    "cvrd"    "cvipe"
hilda_data <- hil_fetch(years = 2001:2003, vars = emp_vars)
dim(hilda_data)
#> [1] 55899    79
```

Here is a summary of the dimensions of our HILDA data files.

``` r
# the number of variables and rows in each wave
nrows_by_wave <-
  hil_fetch(years = 2001:2020, add_basic_vars = F) %>%
  .[, .(number_of_rows = .N), by = wave]

hilda_dictionary[, unlist(wave), by = .(var, label)] %>%
  data.table::setnames("V1", "wave") %>%
  .[!is.na(wave), .(number_of_variables = .N), by = wave] %>%
  merge(nrows_by_wave, by = "wave")
#>     wave number_of_variables number_of_rows
#>  1:    1                4289          19914
#>  2:    2                5220          18295
#>  3:    3                5214          17690
#>  4:    4                5081          17209
#>  5:    5                5893          17467
#>  6:    6                6140          17453
#>  7:    7                6044          17280
#>  8:    8                6186          17144
#>  9:    9                6202          17632
#> 10:   10                6488          17855
#> 11:   11                6691          23415
#> 12:   12                6530          23182
#> 13:   13                6455          23299
#> 14:   14                6719          23114
#> 15:   15                6800          23305
#> 16:   16                6433          23507
#> 17:   17                6697          23442
#> 18:   18                7093          23267
#> 19:   19                7278          23256
#> 20:   20                6864          22932
```
