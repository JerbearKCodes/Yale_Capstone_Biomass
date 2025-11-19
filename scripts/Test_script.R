install.packages("tidyverse")
install.packages("dplyr")
install.packages(c(
  "sf",          # vector spatial data
  "terra",       # raster data
  "exactextractr",# raster-polygon intersections
  "tmap",        # mapping
  "ggplot2",     # plotting
  "dplyr",       # data wrangling
  "readr",       # read CSVs
  "rmapshaper",  # simplify large shapefiles
  "leaflet"      # interactive mapping
))
library(sf)
library(terra)
library(exactextractr)
library(tmap)
library(ggplot2)
library(dplyr)
library(readr)
library(leaflet)

tribes <- st_read("/Users/jkc/Downloads/tl_2019_us_ttract")

st_crs(tribes)     # Coordinate Reference System
st_bbox(tribes)    # Bounding box
plot(st_geometry(tribes))

pnw_bbox <- sf::st_bbox(c(
  xmin = -125,   # west coast
  ymin = 41,     # north of California
  xmax = -111,   # eastern Idaho
  ymax = 50      # southern British Columbia border
), crs = 4326)

tribes_pnw <- st_crop(tribes, pnw_bbox)

# 1. Define PNW bounding box
pnw_bbox <- st_bbox(c(xmin = -125, ymin = 41, xmax = -111, ymax = 50), crs = 4326)

# 2. Load shapefile
tribes <- st_read("data/tribal_boundaries.shp")

# 3. Crop to PNW
tribes_pnw <- st_crop(tribes, pnw_bbox)

# 4. Load raster (optional)
fuel <- rast("data/LF2022_FuelLoad_FLM.tif")
fuel_pnw <- crop(fuel, ext(pnw_bbox))

# 5. Map
tmap_mode("plot")
tm_shape(fuel_pnw) +
  tm_raster(palette = "YlOrRd", title = "Fuel Load") +
  tm_shape(tribes_pnw) +
  tm_borders(col = "blue", lwd = 1.2) +
  tm_layout(title = "Pacific Northwest Biomass & Tribal Lands")
