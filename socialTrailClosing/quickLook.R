library(leaflet)
library(plotKML)
library(yaml)

tbl.27 <- readGPX("Waypoints_27-JUL-20.gpx")$waypoints
tbl.31 <- readGPX("Waypoints_31-JUL-20.gpx")$waypoints

dim(tbl.27)
dim(tbl.31)
tbl <- rbind(tbl.27, tbl.31)

center.lat <- min(tbl$lat) + ((max(tbl$lat) - min(tbl$lat))/2)
center.lon <- min(tbl$lon) + ((max(tbl$lon) - min(tbl$lon))/2)

# center.lat <- sum(tbl$lat)/nrow(tbl)
# center.lon <- sum(tbl$lon)/nrow(tbl)


#tbl <- rbind(tbl.caleb, tbl.mark[, 1:3])

zoom <- 15
options = leafletOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
options.tile <- tileOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
leaflet(options) %>%
    #addProviderTiles(providers$ThunderForest.Landscape, options=options.tile) %>%
    #addProviderTiles(providers$Esri.WorldImagery, options=options.tile) %>%
    addTiles(options=options.tile) %>%
    setView(center.lon, center.lat, zoom=14) %>%
    addCircleMarkers(tbl$lon, tbl$lat, color="red", radius=3, label=tbl$name,
                     popup=sprintf("<a href='https://google.com' target='_blank'>google</a>"),
                     labelOptions = labelOptions(noHide = FALSE, direction = "bottom",
                                                 style = list(
                                                     "color" = "black",
                                                     "font-family" = "serif",
                                                     "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                                     "font-size" = "16px",
                                                     "border-color" = "rgba(0,0,0,0.5)"))
                     ) %>%
    addScaleBar()
