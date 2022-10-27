# setup hilda fst for other functions to use as the test database.
hilda_read_dir <- system.file("extdata", package = "hildar")
hilda_save_dir <- tempdir()
hilda_save_dir <- fs::path(tempdir(), "hildar_fst_testdb")
dir.create(hilda_save_dir)
hil_setup(hilda_read_dir, hilda_save_dir)
options("HILDA_FST"=hilda_save_dir)
