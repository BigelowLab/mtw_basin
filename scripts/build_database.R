source("/mnt/ecocast/projects/btupper/mtw_basin/setup.R")
gompath = andreas::copernicus_path("gom3d")
bb = buffer_basin(read_basin("gom-basins"))
X = dplyr::tribble(
  ~varname, ~product_id, ~dataset_id,
  "thetao", "GLOBAL_MULTIYEAR_PHY_001_030", "cmems_mod_glo_phy_my_0.083deg_P1D-m",
  "thetao", "GLOBAL_MULTIYEAR_PHY_001_030","cmems_mod_glo_phy_myint_0.083deg_P1D-m",
  "thetao", "GLOBAL_ANALYSISFORECAST_PHY_001_024", "cmems_mod_glo_phy-thetao_anfc_0.083deg_P1D-m", 
  "so", "GLOBAL_MULTIYEAR_PHY_001_030", "cmems_mod_glo_phy_my_0.083deg_P1D-m",
  "so", "GLOBAL_MULTIYEAR_PHY_001_030","cmems_mod_glo_phy_myint_0.083deg_P1D-m",
  "so", "GLOBAL_ANALYSISFORECAST_PHY_001_024", "cmems_mod_glo_phy-so_anfc_0.083deg_P1D-m")

db = rowwise(X) |>
  group_map(
    function(grp, key){
      cat("working on ", grp$product_id," : ",grp$dataset_id, " : ", grp$varname,  "\n")
      lut = read_product_lut(grp$product_id) |>
        dplyr::filter(dataset_id == grp$dataset_id, 
                      name == grp$varname)
      dates = seq(from = lut$start_time, to = lut$end_time, by = "day")
      ok = sapply(seq_along(dates),
                  function(i){
                    fetch_gom3d(grp, 
                              bb = bb, 
                              outpath = gompath,
                              date = dates[i])
                  })
      ff = names(ok)
      andreas::decompose_filename(ff, ext = ".nc") |>
        andreas::append_database(file.path(gompath, grp$product_id))
    })