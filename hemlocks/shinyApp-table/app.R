library(R6)
library(shiny)
library(DataTableWidget)
library(rsconnect)
#----------------------------------------------------------------------------------------------------
printf <- function(...) print(noquote(sprintf(...)))
#----------------------------------------------------------------------------------------------------
Sys.setlocale("LC_ALL", "C")
#----------------------------------------------------------------------------------------------------
buttonStyle <- "margin: 5px; margin-right: 0px; font-size: 14px;"

DataTableDemoApp = R6Class("app",

    #--------------------------------------------------------------------------------
    private = list(dtWidget.1 = NULL,
                   tbl = NULL),

    #--------------------------------------------------------------------------------
    public = list(

        initialize = function(){
            printf("initializing demo")
            private$tbl =  read.table("hemlocks.tsv", sep="\t", as.is=TRUE, header=TRUE, quote="")
            private$dtWidget.1 = dataTableWidget$new(id="tbl.1", private$tbl, width="80%",
                                                     height="300px", pageLength=15)
            },

        #------------------------------------------------------------
        ui = function(){
            fluidPage(
                style="padding: 50px; padding-top: 5px;",
                titlePanel("Hemlock Survey"),
                private$dtWidget.1$ui(),
                )
             },
        #------------------------------------------------------------
        server = function(input, output, session){

            private$dtWidget.1$server(input, output, session)
            } # server

       ) # public
    ) # class
#--------------------------------------------------------------------------------
deploy <- function(){
   require(devtools)
   #install_github("PriceLab/BioShiny/MsgBoxWidget", force=TRUE)
   install_github("PriceLab/BioShiny/DataTableWidget", force=TRUE)

   deployApp(account="paulshannon", appName="hemlockDataTable",
             appFiles=c("app.R", "hemlocks.tsv"))
  }
#--------------------------------------------------------------------------------
app <- DataTableDemoApp$new()

if(grepl("hagfish", Sys.info()[["nodename"]]) & !interactive()){
   runApp(shinyApp(app$ui(), app$server), port=1140)
   } else {
   shinyApp(app$ui(), app$server)
   }


