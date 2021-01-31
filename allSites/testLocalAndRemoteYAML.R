library(RUnit)
library(yaml)
#------------------------------------------------------------------------------------------------------------------------
remote.markers.file <- "https://pshannon.net/sewardParkRestoration/config/site.yaml"
remote.regions.yaml.file <- "https://pshannon.net/sewardParkRestoration/config/regions.yaml"

local.markers.file <- "
if(Sys.getenv("mapTesting") == "TRUE"){
   printf("--- using local versions of site.yaml and regions.yaml");
   config.file <- "site.yaml"
   regions.yaml.file <- "regions.yaml"
} else {
    printf("--- using http versions of site.yaml and regions.yaml")
    }
#------------------------------------------------------------------------------------------------------------------------

           config <-  yaml.load(readLines(filename))
           points <- config$points
           tbl <- do.call(rbind, lapply(points, as.data.frame))
           tbl$name <- as.character(tbl$name)
           tbl$details <- as.character(tbl$details)
           tbl$id <- as.character(tbl$id)
           tbl$label <- tbl$name;


          xs <- yaml.load(readLines(regions.yaml.file))[[1]]
          tbls <- lapply(xs, function(x) data.table(name=x$name,
                                                    id=x$id,
                                                    observer=x$observer,
                                                    group=x$group,
                                                    fillColor=x$fillColor,
                                                    borderColor=x$borderColor,
                                                    borderWidth=x$borderWidth,
                                                    opacity=x$opacity,
                                                    details=x$details,
                                                    lat=list(as.numeric(x$lat)),
                                                    lon=list(as.numeric(x$lon))))
          printf("--- found %d regions", length(tbls))
          do.call(rbind, tbls)
