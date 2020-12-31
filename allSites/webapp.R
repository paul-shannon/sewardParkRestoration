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
                                                            color=color,
                                                            radius=radius,
                                                            layerId=name,
                                                            group=group,
                                                            labelOptions=labelOptions(
                                                                style=list("font-size"="20px"))
                                                            ))
          private$map <- addPolygons(private$map,
                                     lng=c(-122.2485912591, -122.2485913429, -122.2487238608, -122.2488163132, -122.2489453945, -122.2490027267, -122.2489564586, -122.248994261, -122.2490202449, -122.2490342427, -122.2490499169,  -122.249145722, -122.2493075766, -122.2492390964, -122.2491707839, -122.2491478175, -122.2490277886, -122.2489582188, -122.2488595638, -122.2487569693, -122.2486739885, -122.2486050893, -122.2485893313, -122.2485298198, -122.2485034168, -122.24838892,      -122.248223545, -122.2481738403, -122.2481705714, -122.2481650393, -122.2480776161, -122.2481429949, -122.248278195,      -122.248288, -122.2484037559),
                                     lat=c(47.5573972799,    47.5573957711,   47.5574039016,    47.5573979504,  47.5574380998,    47.5574949291,   47.5575332344,   47.5575832743,  47.5576318894,   47.5577128585,   47.557743201,     47.5576871261,  47.5576784927,   47.5577761419,   47.5578237511,   47.5578618888,   47.5578719471,   47.5578044727,   47.5578426942,   47.5578716956,   47.5578186382,   47.5578895491,   47.5579264294,   47.5578614697,   47.5578323845,   47.5577306282,     47.5576685183,  47.5576972682,   47.5576328114, 47.55757045, 47.5574639998,           47.5574339088,   47.5573618244,      47.557312,  47.5573186576),
                                     #lng=c(-122.248120,  -122.248710,  -122.248673,  -122.248045),
                                     #lat=c(47.557476,     47.557541,    47.557295,    47.557338),
                                     fillColor="red")

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

         observe({  # with no reactive values included here, this seems to run only at startup.
            printf("--- starting up, search term?")
            searchTerm <- session$clientData$url_search
            searchTerm <- sub("?", "", searchTerm, fixed=TRUE)
            print(searchTerm)
            if(nchar(searchTerm) > 0){
              tbl.sub <- subset(private$tbl, id==searchTerm)
              printf("sites found matching searchTerm: %d", nrow(tbl.sub))
              if(nrow(tbl.sub) == 1){
                 lat <- tbl.sub$lat
                 lon <- tbl.sub$lon
                 isolate({setView(private$proxy, lon, lat, zoom=18)})
                 } # nrow
              } # nchar
            })

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
