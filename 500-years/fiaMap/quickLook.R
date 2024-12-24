library(leaflet)
                                        #
                                        #
#tbl.caleb <- read.table("sixSites.tsv", sep=",", header=TRUE, stringsAsFactors=FALSE)
#tbl.mark  <- read.table("markAndPaulVisit-02jul2020.tsv", sep="\t", header=TRUE, stringsAsFactors=FALSE)
tbl <- read.table("trees.tsv", sep="\t", header=TRUE, as.is=TRUE)
radii <- as.integer(0.5 + tbl$dbh/5)
print(radii)
tbl$radius <- radii

center.lat <- sum(tbl$lat)/nrow(tbl)
center.lon <- sum(tbl$lon)/nrow(tbl)
options = leafletOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
options.tile <- tileOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
leaflet(options) %>%
    #addProviderTiles(providers$ThunderForest.Landscape, options=options.tile) %>%
    #addProviderTiles(providers$Esri.WorldImagery, options=options.tile) %>%
    addTiles(options=options.tile) %>%
    setView(center.lon, center.lat, zoom=14) %>%
    addCircleMarkers(tbl$lon, tbl$lat, color="green", radius=tbl$radius) %>%
    addScaleBar()
#
# map <- leaflet(options)
# addTiles(map, options=options.tile)
# setView(map, center.lon, center.lat, zoom=14)
# addCircleMarkers(map, tbl$lon, tbl$lat, color="blue", radius=tbl$radius)
# addScaleBar(map)
# map

