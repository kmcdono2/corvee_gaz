#x <- c("rgdal", "dplyr", "tidyr", "sf", "ggplot2", "raster", "rasterVis", "sp")
#install.packages(x) # warning: uncommenting this may take a number of minutes
#lapply(x, library, character.only = TRUE) # load the required packages

library(rgdal)
library(dplyr)
library(tidyr)
library(ggplot2)
library(raster)
library(rasterVis)
library(sp)
library(sf)

ogee <- read.csv("~/local/Breton_corvée/geo_ogee_inner.csv")
str(ogee)
names(ogee)
head(ogee$LONG)
head(ogee$LAT)
class(ogee)


#convert to sf object
ogee_sf <- st_as_sf(ogee, coords = c("LONG", "LAT"))
class(ogee_sf)

#add WGS84 CRS
st_crs(ogee_sf) <- NA_character_
st_crs(ogee_sf)
st_crs(ogee_sf) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
st_crs(ogee_sf)

#reproject
ogee93 <- st_transform(ogee_sf, CRS("+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs "))
st_crs(ogee93) <- 2154
st_crs(ogee93)
class(ogee93)

