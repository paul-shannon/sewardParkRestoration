library(shiny)
library(leaflet)
#----------------------------------------------------------------------------------------------------
initial.points <- cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
#----------------------------------------------------------------------------------------------------
ui <- fluidPage(
  leafletOutput("mymap"),
  p(),
  actionButton("recalc", "New points")
  )
#----------------------------------------------------------------------------------------------------
map <- leaflet()
map <- addCircleMarkers(map,
                        lng = runif(10),
                        lat = runif(10),
                        layerId = paste0("marker", 1:10))
#----------------------------------------------------------------------------------------------------
server <- function(input, output, session) {

  output$mymap <- renderLeaflet(map)

  observeEvent(input$mymap_marker_click, {
     proxy <- leafletProxy("mymap", session)
     id <- input$mymap_marker_click$id
     printf("click: %s", id)
     removeMarker(proxy, id)
     })

} # server
#----------------------------------------------------------------------------------------------------
runApp(shinyApp(ui, server), host="0.0.0.0", port=6781)

