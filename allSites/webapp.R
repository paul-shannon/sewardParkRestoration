library(R6)
library(shiny)
library(leaflet)
#----------------------------------------------------------------------------------------------------
printf <- function(...) print(noquote(sprintf(...)))
#----------------------------------------------------------------------------------------------------
library(yaml)

config.file <- "/appData/site.yaml"               # for site.yaml loaded in docker
if(Sys.info()[["sysname"]] == "Darwin")
  config.file <- "site.yaml"                       # for local use, no docker

#----------------------------------------------------------------------------------------------------
MapApp = R6Class("MapAppClass",

    #--------------------------------------------------------------------------------
    private = list(
        map = NULL,
        proxy = NULL,
        tbl = NULL,
        centerLon = NULL,
        centerLat = NULL,
        initialZoom = NULL,
        markerCategories = NULL,

        readConfiguration = function(filename){
           config <-  yaml.load(readLines(filename))
           points <- config$points
           tbl <- do.call(rbind, lapply(points, as.data.frame))
           tbl$name <- as.character(tbl$name)
           tbl$details <- as.character(tbl$details)
           tbl$id <- as.character(tbl$id)
           tbl$label <- tbl$name;
           private$tbl <- tbl
           private$centerLon <- config$centerLon
           private$centerLat <- config$centerLat
           private$initialZoom <- config$initialZoom
           }

    ), # private
    #--------------------------------------------------------------------------------
    public = list(

       initialize = function(){
          private$readConfiguration(config.file)
          private$markerCategories <- sort(unique(private$tbl$group))
          printf("--- markerCategories")
          print(private$markerCategories)

          private$map <- leaflet()
          private$map <- setView(private$map, private$centerLon, private$centerLat, zoom=private$initialZoom)
          options = leafletOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
          options.tile <- tileOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
          private$map <- addTiles(private$map, options=options.tile)

          private$map <- addScaleBar(private$map)
          private$map <- with(private$tbl, addCircleMarkers(private$map,
                                                            lon, lat,
                                                            label=label,
                                                            color=color, radius=radius,
                                                            layerId=name,
                                                            group=group))

          #private$map <- addCircleMarkers(private$map,
          #                                lng = runif(10),
          #                                lat = runif(10),
          #                                layerId = paste0("marker", 1:10))

          }, # initialize
       #--------------------------------------------------------------------------------
       ui = function(){
          fluidPage(
             titlePanel(private$config$title),
             sidebarLayout(
               sidebarPanel(
                   checkboxGroupInput("groupsSelector", "Category", choices=private$markerCategories,
                                      selected=private$markerCategories),
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
                  ) # mainPanel
               ) # sidebarLayout
            ) # fluidPage
          }, # ui
       #--------------------------------------------------------------------------------
       old.ui = function(){
          fluidPage(
             tags$style(type = "text/css", "#sewardMap {height: calc(100vh - 120px) !important;}"),
             leafletOutput("sewardMap"),
             p(),
             actionButton("recalc", "New points")
             )

          }, # old.ui
       #--------------------------------------------------------------------------------
       server = function(input, output, session){

         output$sewardMap <- renderLeaflet(private$map)
         private$proxy <- leafletProxy("sewardMap", session)

         observe({
            req(input$sewardMap_marker_click)
            event <- input$sewardMap_marker_click
            printf("--- map_marker_click: %s", event$id)
            lat <- event$lat
            lon <- event$lng
            details.url <- subset(private$tbl, name==event$id)$details
            if(nchar(details.url) > 20){
                removeUI("#temporaryDiv")
                insertUI("#foo", "beforeEnd", div(id="temporaryDiv"))
                insertUI("#temporaryDiv", "beforeEnd",
                         div(id="detailsDiv", includeHTML(details.url)))
                updateTabsetPanel(session, "mapTabs", selected="siteDetailsTab")    # provided by shiny
                }
            }) # map

         observeEvent(input$selectAllCategoriesButton, ignoreInit=TRUE, {
            printf("--- selectAllCategories")
            updateTabsetPanel(session, "mapTabs", selected="mapTab")
            updateCheckboxGroupInput(session, "groupsSelector", selected=private$markerCategories)
            })

         observeEvent(input$selectNoCategoriesButton, ignoreInit=TRUE, {
            printf("--- selectNoCategories")
            updateCheckboxGroupInput(session, "groupsSelector", selected=character(0))
            updateTabsetPanel(session, "mapTabs", selected="mapTab")
            })

         observeEvent(input$fullViewButton, ignoreInit=TRUE, {
            printf("--- fullViewButton")
            updateTabsetPanel(session, "mapTabs", selected="mapTab")
            setView(private$proxy, lng=private$centerLon, lat=private$centerLat, zoom=private$initialZoom)
            })


         observeEvent(input$groupsSelector, ignoreInit=TRUE, ignoreNULL=FALSE,  {
            printf("--- group change")
            current.groups <- input$groupsSelector
            all.groups <- unique(private$tbl$group)
            hidden.groups <- setdiff(all.groups, current.groups)
            hideGroup(private$proxy, hidden.groups)
            showGroup(private$proxy, current.groups)
            })

         observe({   # helpful in accurate positioning of markers
            x <- input$sewardMap_click
            req(x)
            printf("--- map_click")
            printf("lat: %f", x$lat)
            printf("lon: %f", x$lng)
            })


         } # server
       ) # public
    ) # class
#----------------------------------------------------------------------------------------------------
app <- MapApp$new()

if(grepl("hagfish", Sys.info()[["nodename"]])){
   runApp(shinyApp(app$ui(), app$server), port=1123)
   } else {
   shinyApp(app$ui(), app$server)
   }
