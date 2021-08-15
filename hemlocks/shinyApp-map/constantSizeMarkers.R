library(shiny)
library(leaflet)
library(shinydashboard)
library(shinydashboardPlus)
library(dplyr)
library(yaml)
#------------------------------------------------------------------------------------------------------------------------
config <-  yaml.load(readLines("site.yaml"))
points <- config$points
tbl <- do.call(rbind, lapply(points, as.data.frame))
tbl$name <- as.character(tbl$name)
tbl$details <- as.character(tbl$details)
tbl$id <- as.character(tbl$id)
tbl$label <- tbl$name;
centerLon <- config$centerLon
centerLat <- config$centerLat
initialZoom <- config$initialZoom

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(),
  dashboardBody(
    leafletOutput("map", width = "100%", height = "1000px")

  )
)

#------------------------------------------------------------------------------------------------------------------------
server <- function(input, output,session) {

    observeEvent(
       eventExpr = input$map_zoom, {
         current.zoom <- input$map_zoom
         printf("current.zoom: %f", current.zoom)
         proxy <- leafletProxy(mapId = "map", session = session)
         clearShapes(proxy)
         with(tbl, addCircleMarkers(proxy, lon, lat,
                    weight=1,
                    #weight = case_when(input$map_zoom <=4 ~1,
                    #                          input$map_zoom ==5 ~2,
                    #                          input$map_zoom ==6 ~3,
                    #                          input$map_zoom ==7 ~5,
                    #                          input$map_zoom ==8 ~7,
                    #                          input$map_zoom ==9 ~9,
                    #                          input$map_zoom >9 ~5),
                    opacity = 1,
                    fill = TRUE,
                    radius = round(1+(current.zoom/10)),
                    fillOpacity = 1))


        # leafletProxy(
        #      mapId = "map",
        #        session = session
        #    )%>% clearShapes() %>%
        #        addCircles(data=tbl,lng = ~lon, lat = ~lat,
        #                   weight = case_when(input$map_zoom <=4 ~1,
        #                                      input$map_zoom ==5 ~2,
        #                                      input$map_zoom ==6 ~3,
        #                                      input$map_zoom ==7 ~5,
        #                                      input$map_zoom ==8 ~7,
        #                                      input$map_zoom ==9 ~9,
        #                                      input$map_zoom >9 ~5),
        #                   opacity = 1, fill = TRUE, fillOpacity = 1 )
        }
    )

    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%
            setView(lng=centerLon,
                    lat=centerLat,
                    zoom=initialZoom)
    })
}
#------------------------------------------------------------------------------------------------------------------------
app <- shinyApp(ui, server)
