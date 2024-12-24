library(shiny)
library(leaflet)
#library(plotKML)
#----------------------------------------------------------------------------------------------------
printf <- function(...) print(noquote(sprintf(...)))
#----------------------------------------------------------------------------------------------------
library(yaml)

title <- "Sword Fern Die-off Reports from the Middle Fork of the Snoqualmie River"

filename <- "trees2.tsv"
stopifnot(file.exists(filename))
tbl <- read.table(filename, sep="\t", header=TRUE, as.is=TRUE)

center.lat <- min(tbl$lat) + ((max(tbl$lat) - min(tbl$lat))/2)
center.lon <- min(tbl$lon) + ((max(tbl$lon) - min(tbl$lon))/2)
groups <- sort(unique(tbl$group))
printf("groups: %s", paste(groups, collapse=", "))

#----------------------------------------------------------------------------------------------------
ui <- fluidPage(

  titlePanel(title),
  sidebarLayout(
      sidebarPanel(
         actionButton("fullViewButton", "Full View"),
         br(), br(), br(),
         checkboxGroupInput("groupsSelector", "Category", choices = groups, selected = groups),
         width=2
         ),
      mainPanel(
          tags$style(type = "text/css", "#map {height: calc(100vh - 120px) !important;}"),
          tabsetPanel(type="tabs", id="mapTabs",
                      tabPanel(title="Map", value="mapTab", leafletOutput("map")),
                      tabPanel(title="Site Details", value="siteDetailsTab",
                               div(id="foo"))),# , includeHTML("emptyDetails.html")))
         width=10
         )
     )
)
#----------------------------------------------------------------------------------------------------
server <- function(input, output, session) {


  observeEvent(input$fullViewButton, ignoreInit=TRUE, {
     isolate({
        leafletProxy('map') %>%
           setView(lng=cener.lon, lat=center.lat, zoom=14)
           #setView(lng=config$centerLon, lat=config$centerLat, zoom=config$initialZoom)
        })
      updateTabsetPanel(session, "mapTabs", selected="mapTab")
      })

   observeEvent(input$groupsSelector, ignoreInit=TRUE, ignoreNULL=FALSE,  {
      printf("--- group change")
      print("proxy: ")
      print(proxy)
      all.groups <- sort(unique(tbl$group))
      current.groups <- input$groupsSelector
      #hidden.groups <- setdiff(all.groups, current.groups)
      hideGroup(proxy, all.groups)
      #printf("--- about to show groups: %s", paste(current.groups, collapse=", "))
      #showGroup(proxy, current.groups)
      })

  output$map <- renderLeaflet({
     #currentGroups <- input$groupsSelector
     tbl.sub <- subset(tbl)
     options = leafletOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
     options.tile <- tileOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
     map <- leaflet(options) %>%
         addTiles(options=options.tile) %>%
         setView(center.lon, center.lat, zoom=14) %>%
         addScaleBar()
     if(nrow(tbl.sub) > 0)
         map <- addCircleMarkers(map, tbl.sub$lon, tbl.sub$lat,
                                 label=tbl.sub$name,
                                 color=tbl.sub$color,
                                 radius=tbl.sub$dbh,
                                 layerId=tbl.sub$name)
     map
     })

  proxy <- leafletProxy(title, session)

}
#----------------------------------------------------------------------------------------------------
#with(config, printf("config:  %f   %f   %d", centerLon, centerLat, initialZoom))
runApp(shinyApp(ui, server), host="0.0.0.0", port=6789)
