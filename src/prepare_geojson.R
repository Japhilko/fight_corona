# get zip code areas
# Jan-Philipp Kolb
# Sun Apr 05 11:23:46 2020


# install.packages("rmapshaper")
# install.packages("geojsonio")


# geojson

path <- "E:/github/fight_corona/data/"
base_path <- "E:/github/fight_corona/"
graph_path <- paste0(base_path,"figure/")


plz <- rgdal::readOGR(paste0(path,"post_pl.shp"))


plz2 <- rmapshaper::ms_simplify(plz)

plz3 <- plz2 

library(dplyr)
library(tidyverse)

plz3@data <- plz3@data %>% 
  select(1)

plz3@data <- plz2@data[,1]

# write data --------------------------------------------------------------


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




# Links -------------------------------------------------------------------

# https://dillonshook.com/leaflet-zip-code-map-part-1/
# https://www.reddit.com/r/javascript/comments/88tkg3/question_about_using_leaflet_with_r/
# https://leafletjs.com/examples/geojson/


# https://blog.mapbox.com/rendering-big-geodata-on-the-fly-with-geojson-vt-4e4d2a5dd1f2
