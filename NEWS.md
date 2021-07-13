<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# hildar 0.2.0

- `hil_fetch()` looks for `HILDA_FST` in .Rprofile and .Renviron if not provided by the user. Also, the `.dir` argument is now `hilda_fst_dir`.
- Simplify `hil_setup()` by removing the `n_cores` and `pattern` arguments. See its Notes.
- Renamed `hilda_dict` to `hil_dict`.
- Remove minimum versions of the dependencies.
- Use `hil_` as pkg suffix. `fetch()` and `setup_hildar()` have been renamed to `hil_fetch()` and `hil_setup()`.
# hildar 0.1.0

* Added a `NEWS.md` file to track changes to the package.
