library(R6)
library(shiny)
library(leaflet)
library(data.table)
library(yaml)
library(rsconnect)
#----------------------------------------------------------------------------------------------------
printf <- function(...) print(noquote(sprintf(...)))
#----------------------------------------------------------------------------------------------------
Sys.setlocale("LC_ALL", "C")
#----------------------------------------------------------------------------------------------------

if(Sys.getenv("localConfig") == "TRUE"){
   localConfig <- TRUE
   printf("--- using local versions of site.yaml");
   config.file <- "site.yaml"
} else {
   localConfig <- FALSE
   config.file <-       "https://pshannon.net/hemlockMap/config/site.yaml"
   }

printf("---         localConfig? %s",  localConfig)
printf("---    site config file: %s", config.file)

tooltip.labelOptions <- labelOptions(style=list("font-size"="20px"))
#----------------------------------------------------------------------------------------------------
MapApp = R6Class("MapAppClass",

    #--------------------------------------------------------------------------------
    private = list(
        map = NULL,
        proxy = NULL,
        tbl = NULL,
        currentZoom = NULL,
        centerLon = NULL,
        centerLat = NULL,
        initialZoom = NULL,
        initialGroups = NULL,
        featureGroups = NULL,

        readConfigurationAndMarkers = function(filename){
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
           private$currentZoom <- private$initialZoom
           private$initialGroups <- config$initialGroups
           #printf("-------- initial groups")
           #print(private$initialGroups)
           }

    ), # private
    #--------------------------------------------------------------------------------
    public = list(

       initialize = function(){

          private$readConfigurationAndMarkers(config.file)

          regionCategories <- c()
          markerCategories <- unique(private$tbl$group)
          private$featureGroups <- sort(unique(c(markerCategories)))

          private$map <- leaflet()
          private$map <- setView(private$map, private$centerLon, private$centerLat, zoom=private$initialZoom)
          options <- leafletOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
          options.tile <- tileOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
          private$map <- addTiles(private$map, options=options.tile)

          private$map <- addScaleBar(private$map)
          self$addMarkers(private$initialZoom)
          if(is.data.frame(private$tbl.regions)){
             for(r in seq_len(nrow(private$tbl.regions))){
                 lat <- private$tbl.regions$lat[r][[1]]
                 lon <- private$tbl.regions$lon[r][[1]]
                 label <- private$tbl.regions$name[r]
                 id <-  private$tbl.regions$id[r]
                 group <- private$tbl.regions$group[r]
                 borderWidth <- as.numeric(private$tbl.regions$borderWidth[r])
                 #printf("borderWidth: %d", borderWidth)
                 #printf("fillColor: %s", private$tbl.regions$fillColor[r])
                 opacity <- as.numeric(private$tbl.regions$opacity[r])
                 #printf("opacity: %f", opacity)
                 private$map <- addPolygons(private$map,
                                            lng=lon, lat=lat,
                                            fillColor=private$tbl.regions$fillColor[r],
                                            color=private$tbl.regions$borderColor[r],
                                            label=label,
                                            layerId=id,
                                            group=group,
                                            weight=borderWidth,
                                            fillOpacity=opacity,
                                            labelOptions=tooltip.labelOptions)
                } # for r
             } # if tbl.regions

          if(is.data.frame(private$tbl.tracks)){
            for(r in seq_len(nrow(private$tbl.tracks))){
               #printf("--- track %d", r)
               lon.vec <- private$tbl.tracks$lon[r][[1]]
               lat.vec <- private$tbl.tracks$lat[r][[1]]
               #print(head(lon.vec))
               #print(head(lat.vec))
               group <- private$tbl.tracks$group[r]
               id <- sprintf("track.%d", r)
               color <- private$tbl.tracks$color[r]
               private$map <- addPolylines(private$map,
                                           lng=lon.vec,
                                           lat=lat.vec,
                                           layerId=id,
                                           group=group,
                                           color=color)
            } # for r
            } # if tbl.tracks

          }, # initialize
       #--------------------------------------------------------------------------------
       addMarkers = function(currentZoom){
           map.obj <- private$map
           if(!is.null(private$proxy))
              map.obj <- private$proxy
           zoom.factor <- 1/(14-(currentZoom/2))
           zoom.levels <- c (0:23)
           zoom.factors <- c(0.11, 0.105, 0.100, 0.095, 0.090, 0.095, 0.100, 0.105, 0.110, 0.115,
                             0.1, 0.11, 0.125, 0.14, 0.15, 0.16, 0.18, 0.20,  0.30, 0.60, 0.70, 0.85, 1.05, 1.25)
           tbl.zoomFactors <- data.frame(zoom=zoom.levels, factor=zoom.factors)

           zoomFactor <- subset(tbl.zoomFactors, zoom == currentZoom)$factor
           printf("------ executing addMarkers, %dx, %f factor", currentZoom, zoomFactor)
           with(private$tbl,
                        addCircleMarkers(map.obj,
                                         lon, lat,
                                         label=label,
                                         color=color, # "black",
                                         stroke=TRUE,
                                         weight=2,
                                         fillColor=color,
                                         fillOpacity=1,
                                         radius=radius*zoomFactor,
                                         layerId=name,
                                         group=group,
                                         opacity=1,
                                         labelOptions=tooltip.labelOptions
                                        #clusterOptions = markerClusterOptions()
                                         ))
          }, # addMarkers

       ui = function(){
          fluidPage(
             titlePanel(private$config$title),
             sidebarLayout(
               sidebarPanel(
                   h4("Display Groups?"),
                   div(actionButton("selectAllCategoriesButton", "All"), style="display: inline-block;vertical-align:top; width: 50px;"),
                   div(actionButton("selectNoCategoriesButton", "None"), style="display: inline-block;vertical-align:top; width: 50px;"),
                   br(), br(),
                   checkboxGroupInput("groupsSelector", "Or Select One or More:",
                                      choices=private$featureGroups,
                                      selected=private$initialGroups), # character(0)),
                   br(), br(), br(),
                   actionButton("fullViewButton", "Full Map"),
                   width=2
                   ),
               mainPanel(
                  tags$style(type = "text/css", "#sewardMap {height: calc(100vh - 120px) !important;}"),
                  tabsetPanel(type="tabs", id="mapTabs",
                              tabPanel(title="Map", value="mapTab", leafletOutput("sewardMap")),
                              tabPanel(title="Site Details", value="siteDetailsTab", div(id="foo"))),
                  width=10
                  ) # mainPanel
               ) # sidebarLayout
            ) # fluidPage
          }, # ui
       #--------------------------------------------------------------------------------
       server = function(input, output, session){

         output$sewardMap <- renderLeaflet(private$map)
         private$proxy <- leafletProxy("sewardMap", session)

         query_modal <- modalDialog(
            title = "Usage Tips",
            div(
                tags$head(tags$style(".modal-dialog{ width:1000px}")),
                # tags$head(tags$style(".modal-body{ min-height:700px}")),
                HTML(
                "<ul><li>Select one or more Groups at left: markers will be displayed on the map.
                     <li>Click any marker:  see site details (photos, text, video).
                     <li>The <font color='blue'>Map</font> tab displays the map.
                     <li>The <font color='blue'>Site Details</font> tab displays site-specific information.
                     <li>User your mouse to pan (click &amp; drag) and zoom (mouse wheel).
                     </ul>"),
                style="font-size: 20px; width: 900px;"),
            easyClose = TRUE,
            )

         #showModal(query_modal)
         observeEvent(
           eventExpr = input$sewardMap_zoom, {
              clearMarkers(private$proxy)
              private$currentZoom <- input$sewardMap_zoom
              self$addMarkers(private$currentZoom)
              })

         observe({  # with no reactive values included here, this seems to run only at startup.
            #printf("--- starting up, search term?")
            searchTerm <- session$clientData$url_search
            searchTerm <- sub("?", "", searchTerm, fixed=TRUE)
            #print(searchTerm)
            #printf("--- private$tbl")
            #print(private$tbl)
            if(nchar(searchTerm) > 0){
              tbl.sub <- subset(private$tbl, id==searchTerm)
              printf("sites found matching searchTerm: %d", nrow(tbl.sub))
              if(nrow(tbl.sub) == 1){
                 lat <- tbl.sub$lat
                 lon <- tbl.sub$lon
                 isolate({setView(private$proxy, lon, lat, zoom=18)})
                 } # nrow
              } # nchar
            updateCheckboxGroupInput(session, "groupsSelector", selected=private$initialGroups)
            hideGroup(private$proxy, private$featureGroups)
            showGroup(private$proxy, private$initialGroups)
            })

         observe({
            req(input$sewardMap_marker_click)
            event <- input$sewardMap_marker_click
            printf("--- map_marker_click: %s", event$id)
            lat <- event$lat
            lon <- event$lng
            if(event$id %in% private$tbl$name){
               details.url <- subset(private$tbl, name==event$id)$details
               if(nchar(details.url) > 20){
                  removeUI("#temporaryDiv")
                  insertUI("#foo", "beforeEnd", div(id="temporaryDiv"))
                  insertUI("#temporaryDiv", "beforeEnd",
                           div(id="detailsDiv", includeHTML(details.url)))
                  updateTabsetPanel(session, "mapTabs", selected="siteDetailsTab")    # provided by shiny
                  } # if url
               } # if event id recognized
            }) # map

         observe({
            req(input$sewardMap_shape_click)
            event <- input$sewardMap_shape_click
            printf("--- map_marker_click")
            print(event)
            #printf("--- map_marker_click: %s", event$id)
            lat <- event$lat
            lon <- event$lng
            #print(private$tbl.regions)
            if(event$id %in% private$tbl.regions$id){
               details.url <- subset(private$tbl.regions, id==event$id)$details
               if(nchar(details.url) > 20){
                   removeUI("#temporaryDiv")
                   insertUI("#foo", "beforeEnd", div(id="temporaryDiv"))
                   insertUI("#temporaryDiv", "beforeEnd",
                            div(id="detailsDiv", includeHTML(details.url)))
                   updateTabsetPanel(session, "mapTabs", selected="siteDetailsTab")    # provided by shiny
                   } # if url
                } # if id recognized
            })

         observeEvent(input$selectAllCategoriesButton, ignoreInit=TRUE, {
            printf("--- selectAllCategories")
            updateTabsetPanel(session, "mapTabs", selected="mapTab")
            updateCheckboxGroupInput(session, "groupsSelector", selected=private$featureGroups)
            })

         observeEvent(input$selectNoCategoriesButton, ignoreInit=FALSE, {
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
            all.groups <- private$featureGroups
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
deploy <- function(){
    deployApp(account="paulshannon", appName="hemlockMap",
              appFiles=c("app.R"))
  }

app <- MapApp$new()
# shinyApp(app$ui(), app$server)

if(grepl("hagfish", Sys.info()[["nodename"]]) & !interactive()){
   runApp(shinyApp(app$ui(), app$server), port=1139)
   } else {
   shinyApp(app$ui(), app$server)
   }
