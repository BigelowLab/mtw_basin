#' List the known basin files
#' 
#' @param path chr, the path to the basin datasets
#' @param pattern chr, the file extension pattern 
#' @return chr list of avaiable files
list_basin = function(path = andreas::copernicus_path("regions"),
                       extension = ".gpkg"){
  ff = list.files(path,  
                pattern = glob2rx(paste0("*",extension)))
  sub(extension, "", ff, fixed = TRUE)
}

#' @rdname list_basin
#' @param name the name of the file to read
read_basin = function(name = list_basin()[1],
                      path = andreas::copernicus_path("regions"),
                      extension = ".gpkg"){
  filename = file.path(path,
                       paste0(name[1], extension))
  sf::read_sf(filename)
}

#' Buffer the bounding box of a basing by either a set
#' padding value (in degrees) or by rounding (using `ceiling` and
#' `floor` as appropriate).
#' 
#' @param x sf basing definition
#' @param by chr or numeric.  If numeric add this padding to add/subtract to 
#' bounding box coordinates or by judicous use of ceiling/floor if character.
#' @param plus num, vaue to add beyond the buffering implied by `by`.  Ignored
#'   if `by` is numeric
#' @return bounding boc with same crs as the input `x`.
buffer_basin = function(x = read_basin(),
                        by = "rounding",
                        plus = 0){
  b = sf::st_bbox(x) |> as.vector()
  if (inherits(x, 'numeric')){
    b = b + c(-by, -by, by, by)
  } else {
    b = c(floor(b[1:2]), ceiling(b[3:4]))
    b = b + c(-plus, -plus, plus, plus)
  }
 
  names(b) <- c("xmin", "ymin", "xmax", "ymax")
  sf::st_bbox(b, crs = sf::st_crs(x))
}
