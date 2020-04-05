# get zip code areas
# Jan-Philipp Kolb
# Sun Apr 05 11:23:46 2020


install.packages("rmapshaper")

# geojson

path <- "E:/github/fight_corona/data/"

plz <- rgdal::readOGR(paste0(path,"post_pl.shp"))


plz2 <- rmapshaper::ms_simplify(plz)




# write data --------------------------------------------------------------


rgdal::writeOGR(plz, paste0(path,'plz.geojson'),'dataMap', driver='GeoJSON')

rgdal::writeOGR(plz2, paste0(path,'plz_small.geojson'),'dataMap', driver='GeoJSON')

# Links -------------------------------------------------------------------

# https://dillonshook.com/leaflet-zip-code-map-part-1/
# https://www.reddit.com/r/javascript/comments/88tkg3/question_about_using_leaflet_with_r/
# https://leafletjs.com/examples/geojson/