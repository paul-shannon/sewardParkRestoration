## ----include = FALSE------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)


## ----echo=FALSE-----------------------------------------------------------------------------------
library(leaflet)
library(magrittr)


## ----fig.height=3---------------------------------------------------------------------------------
outline <- quakes[chull(quakes$long, quakes$lat),]

map <- leaflet(quakes) %>%
  # Base groups
  addTiles(group = "OSM (default)") %>%
  addProviderTiles(providers$CartoDB.Positron, group = "Positron (minimal)") %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "World Imagery (satellite)") %>%
  # Overlay groups
  addCircles(
    ~ long,
    ~ lat,
    ~ 10 ^ mag / 5,
    stroke = FALSE,
    group = "Quakes",
    fillColor = "tomato"
  ) %>%
  addPolygons(
    data = outline,
    lng = ~ long,
    lat = ~ lat,
    fill = FALSE,
    weight = 2,
    color = "#FFFFCC",
    group = "Outline"
  ) %>%
  # Layers control
  addLayersControl(
    baseGroups = c(
      "OSM (default)",
      "Positron (minimal)",
      "World Imagery (satellite)"
    ),
    overlayGroups = c("Quakes", "Outline"),
    options = layersControlOptions(collapsed = FALSE)
  )
map


## -------------------------------------------------------------------------------------------------
map %>% hideGroup("Outline")


## -------------------------------------------------------------------------------------------------

quakes <- quakes %>%
  dplyr::mutate(mag.level = cut(mag,c(3,4,5,6),
                                labels = c('>3 & <=4', '>4 & <=5', '>5 & <=6')))

quakes.df <- split(quakes, quakes$mag.level)

l <- leaflet() %>% addTiles()

names(quakes.df) %>%
  purrr::walk( function(df) {
    l <<- l %>%
      addMarkers(data=quakes.df[[df]],
                          lng=~long, lat=~lat,
                          label=~as.character(mag),
                          popup=~as.character(mag),
                          group = df,
                          clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = FALSE),
                          labelOptions = labelOptions(noHide = FALSE,
                                                       direction = 'auto'))
  })

l %>%
  addLayersControl(
    overlayGroups = names(quakes.df),
    options = layersControlOptions(collapsed = FALSE)
  )


