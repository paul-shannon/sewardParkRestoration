library(yaml)
config <-  yaml.load(readLines("regions.yaml"))

           points <- config$points
           tbl <- do.call(rbind, lapply(points, as.data.frame))
           tbl$name <- as.character(tbl$name)

