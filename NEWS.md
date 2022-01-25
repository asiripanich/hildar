<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# hildar 0.2.1.9001

- Improved README.
- `make_dict()` now converts the wave column as integer.
- Removed an old test setup file.
- `hil_setup()` now adds a dictionary file to `save_dir` and should be able to find HILDA files in `read_dir` correctly.
- `hil_fetch()` now works with other releases of HILDA not just release 16, which was unintentionally added.
- Replaced the `hil_dict` object with a `hil_dict()` function that returns it.


# hildar 0.2.1.9000

- Same as previous version.


# hildar 0.2.1

- Properly import packages of used functions.
- Fix wrong warning messages in deprecate functions.

# hildar 0.2.0

- `hil_fetch()` looks for `HILDA_FST` in .Rprofile and .Renviron if not provided by the user. Also, the `.dir` argument is now `hilda_fst_dir`.
- Simplify `hil_setup()` by removing the `n_cores` and `pattern` arguments. See its Notes.
- Renamed `hilda_dict` to `hil_dict`.
- Remove minimum versions of the dependencies.
- Use `hil_` as pkg suffix. `fetch()` and `setup_hildar()` have been renamed to `hil_fetch()` and `hil_setup()`.
# hildar 0.1.0

* Added a `NEWS.md` file to track changes to the package.
