suppressPackageStartupMessages({
  library(cofbb)
  library(sf)
  library(stars)
  library(dplyr)
  library(andreas)
  library(ggplot2)
})

CODEPATH = "/mnt/s1/projects/ecocast/projects/btupper/mtw_basin"
setwd(CODEPATH)
ff = list.files("functions", full.names = TRUE, pattern = glob2rx("*.R"))
for (f in ff) source(f)

outpath = copernicus::copernicus_path("mthw")
temppath = copernicus::copernicus_path("temp")
basins = read_basin("gom-basins")
bb = buffer_basin(basins)
file = 'cmems_mod_glo_phy-thetao_anfc_0.083deg_P1D-m__2025-10-01_thetao.nc'
x = read_stars(file.path(temppath, file)) |> dplyr::slice("time", 1)

