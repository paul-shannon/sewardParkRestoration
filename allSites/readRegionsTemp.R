library(yaml)
library(data.table)

extractRegionsTable <- function(yaml.file){
    xs <- yaml.load(readLines(yaml.file))[[1]]
    tbls <- lapply(xs, function(x) data.table(name=x$name, id=x$id, observer=x$observer, group=x$group, data=x$data, lat=list(x$lat), lon=list(x$lon)))
    do.call(rbind, tbls)
    }

tbl.regions <- extractRegionsTable("regions.yaml")
