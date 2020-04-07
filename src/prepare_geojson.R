# get zip code areas
# Jan-Philipp Kolb
# Sun Apr 05 11:23:46 2020



# Install and load packages -----------------------------------------------


# install.packages("rmapshaper")
# install.packages("geojsonio")

library(dplyr)
library(tidyverse)
library(sp)
library(tmaptools)


# declare paths -----------------------------------------------------------

# geojson

path <- "E:/github/fight_corona/data/"
base_path <- "E:/github/fight_corona/"
graph_path <- paste0(base_path,"figure/")


# Load data ---------------------------------------------------------------

plz <- rgdal::readOGR(paste0(path,"post_pl.shp"))

# simplify the map --------------------------------------------------------

plz2 <- rmapshaper::ms_simplify(plz)

plz4 <- plz3 <- plz2 
plz3@data <- plz3@data %>% 
  select(1)

plz4@data <- plz4@data %>% 
  select(1,3)



# Spatialpoints dataframe -------------------------------------------------

coord_plz <- data.frame(coordinates(plz3))


# get the area size -------------------------------------------------------

plz4@data$area <- raster::area(plz4)
colnames(plz4@data) <- c("plz","name","area")

replace_umlauts <- function(x){
  x <- gsub("ü","ue",x)
  x <- gsub("ä","ae",x)
  x <- gsub("ö","oe",x)
  x <- gsub("Ö","Oe",x)
  x <- gsub("Ä","Ae",x)
  x <- gsub("Ü","Ue",x)
  x <- gsub("ß","ss",x)
  return(x)
}

plz4@data$name <- replace_umlauts(plz4@data$name)


# get the bounding boxes --------------------------------------------------

bbox_plz_list <- list()

for (i in 1:length(plz3)){
  bbox_plz_list[[i]] <- bbox(plz3[i,])
}

plz3@data$long_min <- unlist(lapply(bbox_plz_list,function(x)x[1,1]))
plz3@data$long_max <- unlist(lapply(bbox_plz_list,function(x)x[1,2]))

plz3@data$lat_min <- unlist(lapply(bbox_plz_list,function(x)x[2,1]))
plz3@data$lat_max <- unlist(lapply(bbox_plz_list,function(x)x[2,2]))


# bbox_plz <- bbox(plz)

testdat <- SpatialPointsDataFrame(coord_plz,data.frame(plz3@data))
testdat2 <- SpatialPointsDataFrame(coord_plz,data.frame(plz4@data))




# write data --------------------------------------------------------------

rgdal::writeOGR(testdat, paste0(path,'plzpoints.geojson'),'dataMap', driver='GeoJSON')
rgdal::writeOGR(testdat, paste0(path,'plzpoints_bounds.geojson'),'dataMap', driver='GeoJSON')
rgdal::writeOGR(testdat2, paste0(path,'plzpoints_area.geojson'),'dataMap', driver='GeoJSON')

rgdal::writeOGR(plz, paste0(path,'plz.geojson'),'dataMap', driver='GeoJSON')

rgdal::writeOGR(plz2, paste0(path,'plz_small.geojson'),'dataMap', driver='GeoJSON')

rgdal::writeOGR(plz3, paste0(path,'plz_small2.geojson'),'dataMap', driver='GeoJSON')

rgdal::writeOGR(berlin, paste0(path,'plz_berlin.geojson'),'dataMap', driver='GeoJSON')

# https://cran.r-project.org/web/packages/geojsonio/geojsonio.pdf
geojsonio::topojson_write(input = plz2,file = paste0(path,'plz.topojson'))


# Tests für Städte --------------------------------------------------------

berlin_ind <- substr(plz2@data$PLZ99,1,1)==1
# berlin_ind <- plz2@data$PLZORT99=="Berlin"
hamburg_ind <- grep("Hamburg",plz2@data$PLZORT99)
berlin <- plz2[berlin_ind,]
hamburg <- plz2[hamburg_ind,]

png(paste0(graph_path,"hamburg.png"))
plot(hamburg)
dev.off()


# Karte für Berlin erzeugen -----------------------------------------------

agrep("Berlin",plz2@data$PLZORT99,value=T)

berlin_ind <- plz2@data$PLZORT99 %in% c("Berlin-West","Berlin (östl. Stadtbezirke)")

berlin <- plz2[berlin_ind,]


png(paste0(graph_path,"berlin.png"))
plot(berlin)
dev.off()

# get coordinates of Mannheim ---------------------------------------------

gc_ma <- tmaptools::geocode_OSM("Mannheim")



# Links -------------------------------------------------------------------

# https://cran.r-project.org/web/packages/rmapshaper/vignettes/rmapshaper.html


# https://dillonshook.com/leaflet-zip-code-map-part-1/
# https://www.reddit.com/r/javascript/comments/88tkg3/question_about_using_leaflet_with_r/
# https://leafletjs.com/examples/geojson/


# https://blog.mapbox.com/rendering-big-geodata-on-the-fly-with-geojson-vt-4e4d2a5dd1f2

# https://covmapper.now.sh/

# https://cran.r-project.org/web/packages/sf/vignettes/sf1.html
# https://geocompr.robinlovelace.net/spatial-class.html
# https://r-spatial.github.io/sf/articles/sf1.html
# https://r-spatial.github.io/sf/reference/st_as_sf.html

# https://gis.stackexchange.com/questions/109652/removing-columns-in-a-spatialpolygonsdataframe-in-r

# https://cran.r-project.org/doc/contrib/intro-spatial-rl.pdf
# https://cran.r-project.org/web/packages/sp/vignettes/intro_sp.pdf