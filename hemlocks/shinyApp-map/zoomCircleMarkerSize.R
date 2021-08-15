library(shiny)
library(leaflet)
library(shinydashboard)
library(shinydashboardPlus)
library(dplyr)
ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(),
  dashboardBody(
    leafletOutput("map", width = "100%", height = "500px")

  )
)

server <- function(input, output,session) {

  df <- data.frame("Lat"=c(32.921821,32.910853,32.793803,32.995084,32.683745,32.759999,32.800652,32.958861,32.835963,32.762578,32.649651,32.862843,32.862217,32.936876,32.963381),
                   "Long"=c(-96.840609,-96.738831,-96.689232,-96.857858,-96.825345,-96.684475,-96.794144,-96.816111,-96.676371,-96.897331,-96.944426,-96.754719,-96.856976,-96.752718,-96.770249))

observeEvent(
    eventExpr = input$map_zoom, {
      print(input$map_zoom)           # Display zoom level in the console
      leafletProxy(
        mapId = "map",
        session = session
      )%>% clearShapes() %>%
        addCircles(data=df,lng = ~Long, lat = ~Lat,
                   weight = case_when(input$map_zoom <=4 ~1,
                                      input$map_zoom ==5 ~2,
                                      input$map_zoom ==6 ~3,
                                      input$map_zoom ==7 ~5,
                                      input$map_zoom ==8 ~7,
                                      input$map_zoom ==9 ~9,
                                      input$map_zoom >9 ~11),
                   opacity = 1, fill = TRUE, fillOpacity = 1 )
    }
  )

  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
               attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>%
      setView(lng = -96.84, lat = 32.92, zoom = 6)
  })
}
app <- shinyApp(ui, server)
