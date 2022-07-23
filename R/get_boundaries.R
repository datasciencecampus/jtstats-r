#' Get geo boundary data
#'
#' @param type The type of boundary to return. la (local authority) by default.
#' @return sf object representing LSOA boundaries
#' @export
#' @examples
#' las = get_boundaries()
#' # lsoas = get_boundaries(type = "lsoa")
#' # plot(lsoas$geometry[1:999])
#' jts_04_emp = get_jts(type = "jts04", purpose = "employment", sheet = 2017)
#' summary(las_in_jts <- las[[1]] %in% jts_04_emp$LA_Code)
#' las[[3]][!las_in_jts] # Welsh LAs
get_boundaries = function(type = "la") {
  if(type == "lsoa") {
    # December 2011 EW generalised 20m (BGC) V2
    # u = "https://opendata.arcgis.com/datasets/42f3aa4ca58742e8a55064a213fb27c9_0.geojson"
    u = "https://opendata.arcgis.com/datasets/1f23484eafea45f98485ef816e4fee2d_0.geojson"
  } else if(type == "lpa") {
    u = "https://opendata.arcgis.com/datasets/cc5941be78a8458393a03c69518b2bf9_0.geojson" # April 2020 generalised 20m (BGC)
  } else if(type == "la") {
    # u = "https://opendata.arcgis.com/datasets/3b374840ce1b4160b85b8146b610cd0c_0.geojson" # May 2020 generalised 20m (BGC)
    u = "https://opendata.arcgis.com/datasets/0c09b7cde8b44c4ab6e2a1e47a91e400_0.geojson" # December 2011 EW generalised 20m (BGC)
  }
  res = sf::read_sf(u)
  res
}