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
         checkboxGroupInput("groupsSelector", "Category", choices=markerCategories,
                            selected=markerCategories),
         div(actionButton("selectAllCategoriesButton", "All"), style="display: inline-block;vertical-align:top; width: 50px;"),
         div(actionButton("selectNoCategoriesButton", "None"), style="display: inline-block;vertical-align:top; width: 50px;"),
         br(), br(), br(),
         actionButton("fullViewButton", "Full Map"),
         width=2
         ),
      mainPanel(
          tags$style(type = "text/css", "#sewardMap {height: calc(100vh - 120px) !important;}"),
          tabsetPanel(type="tabs", id="mapTabs",
                      tabPanel(title="Map", value="mapTab", leafletOutput("sewardMap")),
                      tabPanel(title="Site Details", value="siteDetailsTab",
                               div(id="foo"))),
         width=10
         )
     )
)
#----------------------------------------------------------------------------------------------------
map <- leaflet()
map <- setView(map, config$centerLon, config$centerLat, zoom=config$initialZoom)
map <- addScaleBar(map)
map <- addCircleMarkers(map, tbl$lon, tbl$lat, label=tbl$label,
                        color=tbl$color, radius=tbl$radius,
                        layerId=tbl$name)

options = leafletOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
options.tile <- tileOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
map <- addTiles(map, options=options.tile)
#----------------------------------------------------------------------------------------------------
server <- function(input, output, session) {

  output$sewardMap <- renderLeaflet(map)

  observe({  # with no reactive values included here, this seems to run only at startup.
    printf("--- starting up, search term?")
    searchTerm <- session$clientData$url_search
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
     printf("--- fullViewButton")
     updateTabsetPanel(session, "mapTabs", selected="mapTab")
     isolate({
        leafletProxy('map') %>%
           setView(lng=config$centerLon, lat=config$centerLat, zoom=config$initialZoom)
        })
      })

  observeEvent(input$selectAllCategoriesButton, ignoreInit=TRUE,{
     printf("--- selectAllCategories")
     #updateTabsetPanel(session, "mapTabs", selected="mapTab")
     updateCheckboxGroupInput(session, "groupsSelector", selected=markerCategories)
     })

  observeEvent(input$selectNoCategoriesButton, ignoreInit=TRUE,{
     printf("--- selectNoCategories")
     updateCheckboxGroupInput(session, "groupsSelector", selected="snags") #character(0))
     #updateTabsetPanel(session, "mapTabs", selected="mapTab")
     })

  observeEvent(input$clientInfoButton, ignoreInit=FALSE,{
    printf("--- clientInfoButton")
    searchTerm <- session$clientData$url_search
    printf("-- starting up, search term?")
    print(searchTerm)
    })

  observe({
     printf("--- map_click")
     x <- input$map_click
     req(x)
     printf("lat: %f", x$lat)
     printf("lon: %f", x$lng)
     })


  observe({
     printf("--- map_marker_click")
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



#     printf("--- renderLeaflet")
#     currentGroups <- input$groupsSelector
#     printf("--- currentGroups: %s", paste(currentGroups, collapse=","))
#     tbl.sub <- subset(tbl, group %in% currentGroups)
#     print(tbl.sub)
#     options = leafletOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
#     print(133)
#     options.tile <- tileOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
#     print(135)
#     map <- leafletProxy('map')
#     print(137)
#     map <- addTiles(map, options=options.tile)
#     print(139)
#     #print(config)
#     if(nrow(tbl.sub) > 0){
#        printf("=== about to add circleMarkers")
#        map <-addCircleMarkers(map, tbl.sub$lon, tbl.sub$lat, label=tbl.sub$label,
#                               color=tbl.sub$color, radius=tbl.sub$radius,
#                               layerId=tbl.sub$name)
#        }
#     map
#     })
}
#----------------------------------------------------------------------------------------------------
with(config, printf("config:  %f   %f   %d", centerLon, centerLat, initialZoom))
runApp(shinyApp(ui, server), host="0.0.0.0", port=6780)
