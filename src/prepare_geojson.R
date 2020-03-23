# geojson

path <- "E:/github/fight_corona/data/"

plz <- rgdal::readOGR(paste0(path,"post_pl.shp"))

rgdal::writeOGR(plz, paste0(path,'plz.geojson'),'dataMap', driver='GeoJSON')


# Links -------------------------------------------------------------------

# https://dillonshook.com/leaflet-zip-code-map-part-1/
# https://www.reddit.com/r/javascript/comments/88tkg3/question_about_using_leaflet_with_r/
# https://leafletjs.com/examples/geojson/