library(shiny)
library(leaflet)
#library(plotKML)
#----------------------------------------------------------------------------------------------------
printf <- function(...) print(noquote(sprintf(...)))
#----------------------------------------------------------------------------------------------------
library(yaml)

config.file <- "/appData/site.yaml"               # for site.yaml loaded in docker
if(Sys.info()[["sysname"]] == "Darwin")
  config.file <- "site.yaml"                       # for local use, no docker

config <-  yaml.load(readLines(config.file))

points <- config$points
tbl <- do.call(rbind, lapply(points, as.data.frame))
tbl$name <- as.character(tbl$name)
tbl$details <- as.character(tbl$details)
tbl$id <- as.character(tbl$id)
# center.lat <- min(tbl$lat) + ((max(tbl$lat) - min(tbl$lat))/2)
# center.lon <- min(tbl$lon) + ((max(tbl$lon) - min(tbl$lon))/2)
tbl$label <- tbl$name; # with(tbl, sprintf("%s %s (%s)", name, date, observer))
markerCategories <- sort(unique(tbl$group))
#----------------------------------------------------------------------------------------------------
ui <- fluidPage(

  titlePanel(config$title),
  sidebarLayout(
      sidebarPanel(
         #includeCSS("map.css"),
         selectInput("siteSelector", "Select Site", c("-", sort(tbl$label))),
         actionButton("fullViewButton", "Full Map"),
         br(), br(), br(),
         checkboxGroupInput("groupsSelector", "Category", choices = markerCategories, selected=markerCategories),
         div(actionButton("selectAllCategoriesButton", "All"), style="display: inline-block;vertical-align:top; width: 50px;"),
         div(actionButton("selectNoCategoriesButton", "None"), style="display: inline-block;vertical-align:top; width: 50px;"),
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

  observe({  # with no reactive values included here, this seems to run only at startup.
    searchTerm <- session$clientData$url_search
    printf("-- starting up, search term?")
    searchTerm <- sub("?", "", searchTerm, fixed=TRUE)
    print(searchTerm)
    if(nchar(searchTerm) > 0){
      tbl.sub <- subset(tbl, id==searchTerm)
      printf("sites found matching searchTerm: %d", nrow(tbl.sub))
      if(nrow(tbl.sub) == 1){
        lat <- tbl.sub$lat
        lon <- tbl.sub$lon
        isolate({
          leafletProxy('map') %>% setView(lon, lat, zoom=19)
          })
         } # nrow
        } # nchar
    })

  observeEvent(input$fullViewButton, ignoreInit=TRUE, {
     isolate({
        leafletProxy('map') %>%
           setView(lng=config$centerLon, lat=config$centerLat, zoom=config$initialZoom)
        })
      updateTabsetPanel(session, "mapTabs", selected="mapTab")
      })

  observe({
     req(input$siteSelector)
     siteID <- input$siteSelector
     printf("zoom to '%s'", siteID)
     tbl.sub <- subset(tbl, label==siteID)
     if(nrow(tbl.sub) == 1){
        lat <- tbl.sub$lat
        lon <- tbl.sub$lon
        isolate({
          leafletProxy('map') %>%
              setView(lon, lat, zoom=18)
          })
         } # nrow
    })

  observeEvent(input$selectAllCategoriesButton, ignoreInit=TRUE,{
     updateCheckboxGroupInput(session, "groupsSelector", selected=markerCategories)
     })

  observeEvent(input$selectNoCategoriesButton, ignoreInit=TRUE,{
     updateCheckboxGroupInput(session, "groupsSelector", selected=character(0))
     })

  observeEvent(input$clientInfoButton, ignoreInit=FALSE,{
    searchTerm <- session$clientData$url_search
    printf("-- starting up, search term?")
    print(searchTerm)
    })

  observe({
     x <- input$map_click
     printf("lat: %f", x$lat)
     printf("lon: %f", x$lng)
     })


  observe({
     req(input$map_marker_click)
     event <- input$map_marker_click
     print(names(event))
     print(event)
     lat <- event$lat
     lon <- event$lng
     printf("lat: %f  lon: %f", lat, lon)
     details.url <- subset(tbl, name==event$id)$details
     if(nchar(details.url) > 20){
        print(details.url)
        removeUI("#temporaryDiv")
        insertUI("#foo", "beforeEnd", div(id="temporaryDiv"))
        insertUI("#temporaryDiv", "beforeEnd",
                 div(id="detailsDiv", includeHTML(details.url)))
        updateTabsetPanel(session, "mapTabs", selected="siteDetailsTab")    # provided by shiny
        }
     })

  output$map <- renderLeaflet({
     currentGroups <- input$groupsSelector
     tbl.sub <- subset(tbl, group %in% currentGroups)
     options = leafletOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
     options.tile <- tileOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
     map <- leaflet(options) %>%
         addTiles(options=options.tile) %>%
         setView(config$centerLon, config$centerLat, zoom=config$initialZoom) %>%
         addScaleBar()
     if(nrow(tbl.sub) > 0)
         map <- addCircleMarkers(map, tbl.sub$lon, tbl.sub$lat, label=tbl.sub$label,
                                 color=tbl.sub$color, radius=tbl.sub$radius,
                                 layerId=tbl.sub$name)
     map
     })
}
#----------------------------------------------------------------------------------------------------
with(config, printf("config:  %f   %f   %d", centerLon, centerLat, initialZoom))
runApp(shinyApp(ui, server), host="0.0.0.0", port=6789)
