# Craft polygons to define Wilkinson, Georges and Jordan basins.  Saved
# as a geopackage in the 'regions' directory of copernicus data directory


suppressPackageStartupMessages({
  library(cofbb)
  library(sf)
  library(stars)
  library(dplyr)
  library(andreas)
  library(ggplot2)
})


bb = cofbb::get_bb("gom", form = 'sf')
static_path =  copernicus::copernicus_path("chfc", "GLOBAL_ANALYSISFORECAST_PHY_001_024")
outpath = copernicus::copernicus_path("regions")

tmpfile = tempfile(fileext = ".tif")
depth = read_static("deptho", path = static_path, bb = bb) |>
  write_stars(tmpfile) |>
  rlang::set_names("depth")

# these are determined by trial and error
basins = c("wilkinson" = 225, "jordan" = 225, "georges" = 270)
wj = st_contour(depth, breaks = basins[['jordan']], contour_lines = T) |>
  dplyr::mutate(name = LETTERS[seq_len(n())], .before = 1) |>
  dplyr::slice(1:(n()-1)) |>
  sf::st_cast("POLYGON")
wj0 = st_centroid(wj)
plot(depth, main = "Jordan-Wilkinson", reset = F)
plot(wj['name'], add = TRUE, col = NA)
text(wj0['name'], wj$name, col = "green")
keep = dplyr::filter(wj, name %in% c("C", "F")) |>
  dplyr::mutate(name = c("Jordan", "Wilkinson"))

g = st_contour(depth, breaks = basins[['georges']], contour_lines = T) |>
  dplyr::mutate(name = LETTERS[seq_len(n())], .before = 1) |>
  dplyr::slice(1:(n()-1)) |>
  sf::st_cast("POLYGON")
g0 = st_centroid(g)
plot(depth, main = "Georges", reset = F)
plot(g['name'], add = TRUE)
text(g0, g$name, col = "green")
  
g = dplyr::filter(g, name %in% c("B")) |>
  dplyr::mutate(name ="Georges")

keep = dplyr::bind_rows(keep, g)

png(file.path(outpath, "gom-basins.png"))
plot(depth, reset = F)
plot(keep['name'], add = TRUE, col = NA, border = "orange")
text(keep['name'], keep$name, col = "green")
dev.off()

sf::write_sf(keep, file.path(outpath, "gom-basins.gpkg"))

