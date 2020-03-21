# geojson

path <- "E:/github/fight_corona/data/"

plz <- rgdal::readOGR(paste0(path,"post_pl.shp"))

rgdal::writeOGR(plz, paste0(path,'plz.geojson'),'dataMap', driver='GeoJSON')

