source("/mnt/ecocast/projects/btupper/mtw_basin/setup.R")
path = andreas::copernicus_path("gom3d/GLOBAL_MULTIYEAR_PHY_001_030")
bb = buffer_basin(read_basin("gom-basins"))

read_db = function(
    path = copernicus_path("gom3d", "GLOBAL_MULTIYEAR_PHY_001_030", "1993"),
    n = 10){
  list.files(path, pattern = glob2rx("*.nc"), recursive = TRUE) |>
    decompose_filename() |>
    group_by(variable) |>
    slice_head(n = n) 
}

db = read_db()
f = compose_filename(db, path = path, ext = ".nc")

read_3d = function(db, path){
  
  x = dplyr::group_by(db, variable) |>
    dplyr::group_map(
      function(grp, key){
        f = andreas::compose_filename(grp, path, ext = ".nc")
        ss = lapply(f, function(f){stars::read_ncdf(f,var = grp$variable[1]) |>
            dplyr::slice("time",1)})
        do.call(c, append(ss, list(along = list(time = grp$date)))) |>
          rlang::set_names(grp$variable[1])
      }, .keep = TRUE)
  do.call(c, append(x, list(along = NA_integer_)))
}
x = read_3d(db, path)
