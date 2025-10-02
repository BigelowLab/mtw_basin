source("/mnt/ecocast/projects/btupper/mtw_basins/setup.R")
gompath = copernicus_path("gom3d")
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
      lut = read_product_lut(grp$product_id) |>
        dplyr::filter(dataset_id == grp$dataset_id, 
                      name == grp$varname)
      
    }
  )