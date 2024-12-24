library(shiny)
library(leaflet)

quakes <- quakes %>%
  dplyr::mutate(mag.level = cut(mag,c(3,4,5,6),
                                labels = c('>3 & <=4', '>4 & <=5', '>5 & <=6')))

quakes.df <- split(quakes, quakes$mag.level)


r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()
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
    overlayGroups = names(quakes.df),
    options = layersControlOptions(collapsed = FALSE)
    ) %>%
   addLayersControl(
    baseGroups = c(
      "OSM (default)",
      "Positron (minimal)",
      "World Imagery (satellite)"
    ),
    overlayGroups = c("Quakes", "Outline"),
    options = layersControlOptions(collapsed = FALSE)
  )


ui <- fluidPage(
  leafletOutput("mymap"),
  p(),
  actionButton("recalc", "New points")
  )

server <- function(input, output, session) {

  points <- eventReactive(input$recalc, {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    }, ignoreNULL = FALSE)

  output$mymap <- renderLeaflet(map)
  }


runApp(shinyApp(ui, server), host="0.0.0.0", port=6789)
