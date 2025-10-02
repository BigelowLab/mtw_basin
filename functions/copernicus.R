#' Downlaod a copernicus daily dataset
#' 
#' data are stored in ncdf format
#' @param x table with varname, product_id and dataset_id
#' @param varname the name of the variable
#' @param bb object containing the spatial bounding box
#' @param depth num, min and max depths for search
#' @param date Date the date to download
#' @param lut table, the product lut
#' @param ... ignored
#' @return 0 for sucess and non-zero otherwise
fetch_gom3d = function(x,
    bb = buffer_basin(read_basin("gom-basins")),
    outpath = copernicus::copernicus_path("gom3d"),
    depth = c(0.49, 320),
    date = Sys.Date(),
    lut = read_product_lut(x$product_id),
    ...){
  
  
  opath = file.path(outpath,
                    )
  copernicus::download_copernicus_cli_subset(
    dataset_id = dataset_id,
    vars = "thetao",
    bb = sf::st_bbox(bb),
    depth = c(0.49, 320),
    time = c(date, date),
    ofile = file.path(outpath, 
                      sprintf("%s__%s_multi_day_%s_raw.nc",
                              dataset_id[1],
                              format(date, "%Y-%m-%dT000000"),
                              varname[1] )),
    ...)
}