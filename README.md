
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hildar

<!-- badges: start -->

[![R-CMD-check](https://github.com/asiripanich/hildar/workflows/R-CMD-check/badge.svg)](https://github.com/asiripanich/hildar/actions)

<!-- badges: end -->
<p align="center">
<img src="https://fbe.unimelb.edu.au/_nocache?a=3881339" title="source: https://fbe.unimelb.edu.au/_nocache?a=3881339" width="400"/>
</p>

[HILDA survey data](https://melbourneinstitute.unimelb.edu.au/hilda) is
a large panel survey with close to 20 waves (2001 - 2020), and some
waves have more than 5000 variables, which makes reading them into R a
little challenging.

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
quickly, a lot faster than `.dta`.

``` r
hil_setup(dir_input = "/path/to/your/hilda-stata-files", dir_output = "/path/to/save/hilda-fst-files")
```

This will allow you to fast query the data across all waves using
`hil_fetch()`.

### 2) Tell `hildar` where the HILDA `.fst` files are stored at.

`hil_fetch()` requires the user to tell it where the HILDA fst files
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
#> ! These variables: `cnpu_fd`, `cnpu_np`, `cnpu_o1`, `cnpu_o2`, `cnpu_na`, `cnph_o1`, `cnph_o2`, `cnpc_ps`, `cnpc_fd`, `cnpc_o1`, `cnpc_o2`, `cnsu_ps`, `cnsu_fd`, `cnsu_kp`, `cnsu_np`, `cnsu_o1`, `cnsu_o2`, `cnsu_na`, `cnsh_bs`, `cnsh_ru`, `cnsh_re`, `cnsh_ps`, `cnsh_fd`, `cnsh_kp`, `cnsh_o1`, `cnsh_o2`, `cnsc_bs`, `cnsc_ru`, `cnsc_ps`, `cnsc_fd`, `cnsc_kp`, `cnsc_o1`, `cnsc_o2`, `chkb12`, `pjothru`, `pjothra`, `pjotcnt`, `fmfempn`, `fmmempn`, `lshremp`, `lsmnemp`, `lsmncom`, `fisemr`, `lsemp`, `lscom`, `jbtremp`, `ujtros`, `ncesop`, `rcesop`, `rtgwage`, `cnsh_au`, `hepuwrk`, `herjob`, `herhour`, `hechjob`, `hetowrk`, `heonas`, `hespeq`, `heothed`, `nsu1_fd`, `nsu1_o1`, `nsu1_o2`, `nsu1_na`, `nsu1_np`, `nsu2_fd`, `nsu2_o1`, `nsu2_o2`, `nsu2_na`, `nsu2_np`, `nsu3_fd`, `nsu3_o1`, `nsu3_o2`, `nsu3_na`, `nsu3_np`, `nsu4_fd`, `nsu4_o1`, `nsu4_o2`, `nsu4_na`, `nsu4_np`, `nsu5_fd`, `nsu5_o1`, `nsu5_o2`, `nsu5_na`, `nsu5_np`, `nsu6_fd`, `nsu6_o1`, `nsu6_o2`, `nsu6_na`, `nsu6_np`, `nsh1_ps`, `nsh2_ps`, `nsh3_ps`, `nsh4_ps`, `nsh5_ps`, `nsh6_ps`, `nsh1_fd`, `nsh2_fd`, `nsh3_fd`, `nsh4_fd`, `nsh5_fd`, ... don't exist in 'C:\Users\amarin\OneDrive - UNSW\data\HILDA20-fst/Combined_a200u.fst'.
#> ! These variables: `fmfempo`, `fmmempo`, `jbempst`, `loimpew`, `jbtremp`, `ujtros`, `ncesop`, `rcesop`, `rtgwage`, `cnsh_au`, `hepuwrk`, `herjob`, `herhour`, `hechjob`, `hetowrk`, `heonas`, `hespeq`, `heothed`, `nsu1_fd`, `nsu1_o1`, `nsu1_o2`, `nsu1_na`, `nsu1_np`, `nsu2_fd`, `nsu2_o1`, `nsu2_o2`, `nsu2_na`, `nsu2_np`, `nsu3_fd`, `nsu3_o1`, `nsu3_o2`, `nsu3_na`, `nsu3_np`, `nsu4_fd`, `nsu4_o1`, `nsu4_o2`, `nsu4_na`, `nsu4_np`, `nsu5_fd`, `nsu5_o1`, `nsu5_o2`, `nsu5_na`, `nsu5_np`, `nsu6_fd`, `nsu6_o1`, `nsu6_o2`, `nsu6_na`, `nsu6_np`, `nsh1_ps`, `nsh2_ps`, `nsh3_ps`, `nsh4_ps`, `nsh5_ps`, `nsh6_ps`, `nsh1_fd`, `nsh2_fd`, `nsh3_fd`, `nsh4_fd`, `nsh5_fd`, `nsh6_fd`, `nsh1_o1`, `nsh2_o1`, `nsh3_o1`, `nsh4_o1`, `nsh5_o1`, `nsh6_o1`, `nsh1_o2`, `nsh2_o2`, `nsh3_o2`, `nsh4_o2`, `nsh5_o2`, `nsh6_o2`, `npu1_o1`, `npu1_o2`, `npu1_na`, `npu1_np`, `npu2_o1`, `npu2_o2`, `npu2_na`, `npu2_np`, `npu3_o1`, `npu3_o2`, `npu3_na`, `npu3_np`, `npu4_o1`, `npu4_o2`, `npu4_na`, `npu4_np`, `npu5_o1`, `npu5_o2`, `npu5_na`, `npu5_np`, `npu6_o1`, `npu6_o2`, `npu6_na`, `npu6_np`, `nph1_fd`, `nph2_fd`, `nph3_fd`, `nph4_fd`, ... don't exist in 'C:\Users\amarin\OneDrive - UNSW\data\HILDA20-fst/Combined_b200u.fst'.
#> ! These variables: `fmfempo`, `fmmempo`, `jbempst`, `loimpew`, `fisemr`, `cnsh_au`, `hepuwrk`, `herjob`, `herhour`, `hechjob`, `hetowrk`, `heonas`, `hespeq`, `heothed`, `nsu1_fd`, `nsu1_o1`, `nsu1_o2`, `nsu1_na`, `nsu1_np`, `nsu2_fd`, `nsu2_o1`, `nsu2_o2`, `nsu2_na`, `nsu2_np`, `nsu3_fd`, `nsu3_o1`, `nsu3_o2`, `nsu3_na`, `nsu3_np`, `nsu4_fd`, `nsu4_o1`, `nsu4_o2`, `nsu4_na`, `nsu4_np`, `nsu5_fd`, `nsu5_o1`, `nsu5_o2`, `nsu5_na`, `nsu5_np`, `nsu6_fd`, `nsu6_o1`, `nsu6_o2`, `nsu6_na`, `nsu6_np`, `nsh1_ps`, `nsh2_ps`, `nsh3_ps`, `nsh4_ps`, `nsh5_ps`, `nsh6_ps`, `nsh1_fd`, `nsh2_fd`, `nsh3_fd`, `nsh4_fd`, `nsh5_fd`, `nsh6_fd`, `nsh1_o1`, `nsh2_o1`, `nsh3_o1`, `nsh4_o1`, `nsh5_o1`, `nsh6_o1`, `nsh1_o2`, `nsh2_o2`, `nsh3_o2`, `nsh4_o2`, `nsh5_o2`, `nsh6_o2`, `npu1_o1`, `npu1_o2`, `npu1_na`, `npu1_np`, `npu2_o1`, `npu2_o2`, `npu2_na`, `npu2_np`, `npu3_o1`, `npu3_o2`, `npu3_na`, `npu3_np`, `npu4_o1`, `npu4_o2`, `npu4_na`, `npu4_np`, `npu5_o1`, `npu5_o2`, `npu5_na`, `npu5_np`, `npu6_o1`, `npu6_o2`, `npu6_na`, `npu6_np`, `nph1_fd`, `nph2_fd`, `nph3_fd`, `nph4_fd`, `nph5_fd`, `nph6_fd`, `nph1_o1`, `nph2_o1`, ... don't exist in 'C:\Users\amarin\OneDrive - UNSW\data\HILDA20-fst/Combined_c200u.fst'.
dim(hilda_data)
#> [1] 55899    79
```

Or if you know the prefix of a subject area that you like to query, you
can use `hil_vars(pattern)` to query all variable names that match the
pattern. For example, `hil_vars("^ff")` will get all variables in
subject area ‘Health’ and nested area ‘Heath - diet’.

``` r
hilda_data <- hil_fetch(years = 2001:2003, vars = hil_vars("^ff"))
#> ! These variables: `ffmilk`, `ffveg`, `ffvegs`, `fffrt`, `fffrts`, `ffbf`, `ffsalt`, `ffbrfr`, `fflunr`, `ffdinr`, `ffcdiet`, `ffdietf`, `ffsrw`, `ffscw`, `ffleg`, `ffcake`, `ffpasta`, `ffsnack`, `ffcerl`, `ffconf`, `ffbread`, `ffspud`, `ffrmeat`, `ffprocm`, `ffpoult`, and `fffish` don't exist in 'C:\Users\amarin\OneDrive - UNSW\data\HILDA20-fst/Combined_a200u.fst'.
#> ! These variables: `ffmilk`, `ffveg`, `ffvegs`, `fffrt`, `fffrts`, `ffbf`, `ffsalt`, `ffbrfr`, `fflunr`, `ffdinr`, `ffcdiet`, `ffdietf`, `ffsrw`, `ffscw`, `ffleg`, `ffcake`, `ffpasta`, `ffsnack`, `ffcerl`, `ffconf`, `ffbread`, `ffspud`, `ffrmeat`, `ffprocm`, `ffpoult`, and `fffish` don't exist in 'C:\Users\amarin\OneDrive - UNSW\data\HILDA20-fst/Combined_b200u.fst'.
#> ! These variables: `ffmilk`, `ffveg`, `ffvegs`, `fffrt`, `fffrts`, `ffbf`, `ffsalt`, `ffbrfr`, `fflunr`, `ffdinr`, `ffcdiet`, `ffdietf`, `ffsrw`, `ffscw`, `ffleg`, `ffcake`, `ffpasta`, `ffsnack`, `ffcerl`, `ffconf`, `ffbread`, `ffspud`, `ffrmeat`, `ffprocm`, `ffpoult`, and `fffish` don't exist in 'C:\Users\amarin\OneDrive - UNSW\data\HILDA20-fst/Combined_c200u.fst'.
dim(hilda_data)
#> [1] 55899     9
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
