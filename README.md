
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hildar

<!-- badges: start -->

[![R-CMD-check](https://github.com/asiripanich/hildar/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/asiripanich/hildar/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

<p align="center">
<img src="https://fbe.unimelb.edu.au/_nocache?a=3881339" title="source: https://fbe.unimelb.edu.au/_nocache?a=3881339" width="400"/>
</p>

[HILDA survey data](https://melbourneinstitute.unimelb.edu.au/hilda) is
a large panel survey 20 waves (2001 - 2020) and counting! Some waves
have more than 5000 variables, which means reading them into R is a
little challenging (personally I think it is wayyyyyyyy too slow).

The goal of this package is to provide a quick and easy way to query
HILDA data into R. This is possible by converting each wave of HILDA
from its STATA file (`.dta`), one of the three formats HILDA provides,
to `fst` format. [fst](https://github.com/fstpackage/fst) is a binary
format and can be read much much quicker than `.dta` in R.

| Function name          | Description                                                                                                                                                                               |
|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `hil_setup()`          | Setup HILDA fst files for `hil_fetch() to use`.                                                                                                                                           |
| `hil_fetch()`          | Fetches HILDA records based on query options.                                                                                                                                             |
| `hil_dict()`           | Shows HILDA data glossary and waves each variable is available in. This provides a convenient way to select multiple variables based on their description by passing it to `hil_fetch()`. |
| `hil_vars()`           | Returns all variables where their variable names match a regular expression.                                                                                                              |
| `hil_labs()`           | Returns all variables where their labels match a regular expression.                                                                                                                      |
| `hil_browse()`         | Opens up the HILDA data dictionary page on your default web browser.                                                                                                                      |
| `hil_crosswave_info()` | Takes a variable name and search for its cross wave information.                                                                                                                          |
| `hil_var_details()`    | Similar to `hil_crosswave_info()` but it searches for a variable’s details.                                                                                                               |

## Installation

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("asiripanich/hildar")
```

## Setup

### 1) Store HILDA as `.fst` files

Use `hil_setup()` to read HILDA STATA (.dta) files and save them as
`.fst` files. `.fst` is a binary data format that can be read very
quickly, a lot faster than `.dta`. An additional benefit of
`hil_setup()` is that it creates a HILDA dictionary file that you can
later call using `hil_dict()`. Having a functional `hil_dict()` allows
the user to use `hil_vars()` and `hil_labs()` for searching variable
names using a regular expression.  
This will allow you to fast query HILDA data from all waves using
`hil_fetch()`.

``` r
hil_setup(
  read_dir = "/path/to/your/hilda-stata-files", 
  save_dir = "/path/to/save/hilda-fst-files"
)
```

To speed up the setup process, you can select a `future` parallel
backend and call it before running your `hil_setup()`.

``` r
library(future)
plan(multisession, workers = 2)

# `hil_setup()` can take several minutes to finish.
# To monitor its progress, you can wrap the function in
# `progressr::with_progress({...}}` like below.
progressr::with_progress({
   hil_setup(read_dir = "...", save_dir = "...")
})
```

### 2) Tell `hildar` where the HILDA `.fst` files are stored at.

`hil_fetch()` requires the user to specify where the HILDA fst files
generated in the previous step are stored. You can either set this
`HILDA_FST` as a global option or an R environment variable. Setting
this as a persistent option for all your R sessions will make
`hil_fetch()` more convinient to use. Alternatively, you can manually
set it in each call using `hilda_fst_dir` argument in `hil_fetch()`.

## Example

Once the setup is completed, you can now start fetching HILDA data with
`hildar`!

``` r
library(hildar)

# fetch removes the HILDA year prefix from all the selected variable
# (e.g. axxx = 2001, bxxx = 2002).
hil_fetch(years = 2001:2003, add_geography = T) %>%
  summary()
#> ℹ `HILDAR_USER_DEFAULT_VARS` in Renviron: `hhid`
#> fstcore package v0.9.12
#> (OpenMP was not detected, using single threaded mode)
#>    xwaveid              hhid                wave          hhwth             hhwtrp            hgage           hgsex              mrcurr             hhrih              hhsgcc         
#>  Length:55899       Length:55899       Min.   :1.00   Min.   :    0.0   Min.   :  -10.0   Min.   :  0.00   Length:55899       Length:55899       Length:55899       Length:55899      
#>  Class :character   Class :character   1st Qu.:1.00   1st Qu.:  732.7   1st Qu.:  -10.0   1st Qu.: 15.00   Class :character   Class :character   Class :character   Class :character  
#>  Mode  :character   Mode  :character   Median :2.00   Median :  909.4   Median :  821.9   Median : 34.00   Mode  :character   Mode  :character   Mode  :character   Mode  :character  
#>                                        Mean   :1.96   Mean   : 1021.9   Mean   :  809.4   Mean   : 34.82                                                                              
#>                                        3rd Qu.:3.00   3rd Qu.: 1148.8   3rd Qu.: 1122.0   3rd Qu.: 51.00                                                                              
#>                                        Max.   :3.00   Max.   :14094.0   Max.   :16000.0   Max.   :100.00
```

There is a quick option to add basic demographic variables to the data,
which is set to TRUE by default.

``` r
hil_fetch(years = 2001, add_basic_vars = T) %>%
  names()
#> ℹ `HILDAR_USER_DEFAULT_VARS` in Renviron: `hhid`
#> [1] "xwaveid" "hhid"    "wave"    "hhwth"   "hhwtrp"  "hgage"   "hgsex"   "mrcurr"  "hhrih"
```

How about doing a quick search to find variables that you want? Use
`hil_dict` which is a data.table that you can search or view HILDA
variables without going to their documentation webpage.

``` r
hilda_dictionary <- hil_dict()
head(hilda_dictionary)
#>        var            wave                    label
#> 1: xwaveid              NA         XW Cross wave ID
#> 2:    hhid 1,2,3,4,5,6,...          HF Household ID
#> 3:   hhpno 1,2,3,4,5,6,...         HF Person number
#> 4:   hhpid 1,2,3,4,5,6,...             HF Person ID
#> 5:  hhrpid 1,2,3,4,5,6,... DV: Randomised person id
#> 6: hhstate 1,2,3,4,5,6,...                 HF State
```

Let say we want to select all variables that are related to
‘employment’. Here is how we can easily use the selected employment
variables in `hil_fetch()`.

``` r
hilda_data <- hil_fetch(years = 2001:2003, vars = hil_labs("employment"))
#> ℹ `HILDAR_USER_DEFAULT_VARS` in Renviron: `hhid`
#> ! These variables: `cnpu_fd`, `cnpu_np`, `cnpu_o1`, `cnpu_o2`, `cnpu_na`, `cnph_o1`, `cnph_o2`, `cnpc_ps`, `cnpc_fd`, `cnpc_o1`, `cnpc_o2`, `cnsu_ps`, `cnsu_fd`, `cnsu_kp`, `cnsu_np`, `cnsu_o1`, `cnsu_o2`, `cnsu_na`, …, `cvrd`, and `cvipe` don't exist in '/Users/amarin/OneDrive - UNSW/data/HILDA20-fst/Combined_a200u.fst'.
#> ! These variables: `fmfempo`, `fmmempo`, `jbempst`, `loimpew`, `jbtremp`, `ujtros`, `ncesop`, `rcesop`, `rtgwage`, `cnsh_au`, `hepuwrk`, `herjob`, `herhour`, `hechjob`, `hetowrk`, `heonas`, `hespeq`, `heothed`, …, `cvrd`, and `cvipe` don't exist in '/Users/amarin/OneDrive - UNSW/data/HILDA20-fst/Combined_b200u.fst'.
#> ! These variables: `fmfempo`, `fmmempo`, `jbempst`, `loimpew`, `fisemr`, `cnsh_au`, `hepuwrk`, `herjob`, `herhour`, `hechjob`, `hetowrk`, `heonas`, `hespeq`, `heothed`, `nsu1_fd`, `nsu1_o1`, `nsu1_o2`, `nsu1_na`, …, `cvrd`, and `cvipe` don't exist in '/Users/amarin/OneDrive - UNSW/data/HILDA20-fst/Combined_c200u.fst'.
dim(hilda_data)
#> [1] 55899    79
```

Or if you know the prefix of a subject area that you like to query, you
can use `hil_vars(pattern)` to query all variable names that match the
pattern. For example, `hil_vars("^ff")` will get all variables in
subject area ‘Health’ and nested area ‘Heath - diet’.

``` r
hilda_data <- hil_fetch(years = 2001:2003, vars = hil_vars("^ff"))
#> ℹ `HILDAR_USER_DEFAULT_VARS` in Renviron: `hhid`
#> ! These variables: `ffmilk`, `ffveg`, `ffvegs`, `fffrt`, `fffrts`, `ffbf`, `ffsalt`, `ffbrfr`, `fflunr`, `ffdinr`, `ffcdiet`, `ffdietf`, `ffsrw`, `ffscw`, `ffleg`, `ffcake`, `ffpasta`, `ffsnack`, …, `ffpoult`, and `fffish` don't exist in '/Users/amarin/OneDrive - UNSW/data/HILDA20-fst/Combined_a200u.fst'.
#> ! These variables: `ffmilk`, `ffveg`, `ffvegs`, `fffrt`, `fffrts`, `ffbf`, `ffsalt`, `ffbrfr`, `fflunr`, `ffdinr`, `ffcdiet`, `ffdietf`, `ffsrw`, `ffscw`, `ffleg`, `ffcake`, `ffpasta`, `ffsnack`, …, `ffpoult`, and `fffish` don't exist in '/Users/amarin/OneDrive - UNSW/data/HILDA20-fst/Combined_b200u.fst'.
#> ! These variables: `ffmilk`, `ffveg`, `ffvegs`, `fffrt`, `fffrts`, `ffbf`, `ffsalt`, `ffbrfr`, `fflunr`, `ffdinr`, `ffcdiet`, `ffdietf`, `ffsrw`, `ffscw`, `ffleg`, `ffcake`, `ffpasta`, `ffsnack`, …, `ffpoult`, and `fffish` don't exist in '/Users/amarin/OneDrive - UNSW/data/HILDA20-fst/Combined_c200u.fst'.
dim(hilda_data)
#> [1] 55899     9
```

To set default variables to be loaded every time you call `hil_fetch()`,
see `hil_user_default_vars()`.

Here is a summary of the dimensions of our HILDA data files.

``` r
# the number of variables and rows in each wave
nrows_by_wave <-
  hil_fetch(years = 2001:2020, add_basic_vars = F) %>%
  .[, .(number_of_rows = .N), by = wave]
#> ℹ `HILDAR_USER_DEFAULT_VARS` in Renviron: `hhid`

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
