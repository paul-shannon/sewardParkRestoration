library(shiny)
library(leaflet)

quakes <- quakes %>%
  dplyr::mutate(mag.level = cut(mag,c(3,4,5,6),
                                labels = c('>3 & <=4', '>4 & <=5', '>5 & <=6')))

quakes.df <- split(quakes, quakes$mag.level)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()
outline <- quakes[chull(quakes$long, quakes$lat),]

map <- leaflet()
addTiles(map, group = "OSM (default)")
addProviderTiles(map, providers$CartoDB.Positron, group = "Positron (minimal)")
addProviderTiles(map, providers$Esri.WorldImagery, group = "World Imagery (satellite)")
addCircles(map,
           quakes$long,
           quakes$lat,
           10^(quakes$mag/5),
           stroke = FALSE,
           group = "Quakes",
           fillColor = "tomato"
           )
addPolygons(map,
            data = outline,
            lng = quakes$long,
            lat = quakes$lat,
            fill = FALSE,
            weight = 2,
            color = "#FFFFCC",
            group = "Outline"
            )
addLayersControl(map,overlayGroups = names(quakes.df),
                 options = layersControlOptions(collapsed = FALSE)
                 )
addLayersControl(map, baseGroups = c("OSM (default)",
                                     "Positron (minimal)",
                                     "World Imagery (satellite)"
                                     ),
                 overlayGroups = c("Quakes", "Outline"),
                 options = layersControlOptions(collapsed = FALSE)
                 )

hideGroup(map, "Outline")

quakes <- quakes %>%
  dplyr::mutate(mag.level = cut(mag,c(3,4,5,6),
                                labels = c('>3 & <=4', '>4 & <=5', '>5 & <=6')))
quakes.df <- split(quakes, quakes$mag.level)

leaflet <- leaflet()
addTiles(leaflet)

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

addLayersControl(leaflet,
    overlayGroups = names(quakes.df),
    options = layersControlOptions(collapsed = FALSE)
    )

#--------------------------------------------------------------------------------
ui <- fluidPage(
  leafletOutput("mymap"),
  p(),
  actionButton("recalc", "New points")
  )

#--------------------------------------------------------------------------------
server <- function(input, output, session) {

  points <- eventReactive(input$recalc, {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    }, ignoreNULL = FALSE)
  output$mymap <- renderLeaflet(map)
  }
#--------------------------------------------------------------------------------
runApp(shinyApp(ui, server), host="0.0.0.0", port=6789)
