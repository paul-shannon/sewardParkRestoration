library(plotKML)
library(leaflet)

f <- "Waypoints_12-JUL-20.gpx"
coi <- c("lon", "lat", "time", "name")
tbl <- readGPX(f)$waypoints[-1, coi]   # second waypoint redundant
colnames(tbl) <- c("lon", "lat", "time", "waypoint")

dbh <- list(18,
            5,
            )

# wp14 14'4"
# wp15 13 2  north side of hatchery trail, 15' off trail
# wp16 14 10 further south
# wp17 12 5   one snag right next to one burned stump
# wp18        inaudible, missing, burned stump
# wp19 13 1   big healthy tree on a slope futher south
# wp20 14 6   big healthy fir just east of wp 19
# wp21 10 3   upslope considerably, smaller snag,
# wp22        missing
# wp23 16'    snag, old, red huckleberry, small fern and hemlock growing out of it


comments <- list("dead cedar tree",
                 "dead cherry tree",
            )

options = leafletOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
options.tile <- tileOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
leaflet(options) %>%
    #addProviderTiles(providers$ThunderForest.Landscape, options=options.tile) %>%
    #addProviderTiles(providers$Esri.WorldImagery, options=options.tile) %>%
    addTiles(options=options.tile) %>%
    setView(-122.25200, 47.555500, zoom=16) %>%
    addCircleMarkers(tbl$lon, tbl$lat, radius=1, popup=tbl$waypoint) %>%
    addScaleBar()



#                     popup="yahoo!")
#    addPopups(-122.2518, 47.55960, "big tree")

setView(map, -122.25200, 47.555500, zoom=16)
map <- with(tbl, addCircleMarkers(map, lng=lon, lat=lat, radius=5, popup="yahoo!"))
#                                color=~pal(status),
#                                fillColor=~pal(status),
#                                fillOpacity=1
#                                ))
map

addPopups(
