library(leaflet)
tbl <- read.table("reviewed-2020-jun-27.tsv", sep="\t", as.is=TRUE, header=TRUE, nrow=-1, quote="")

pal <- colorFactor(c("black", "#996633"), domain = c("burn", "noBurn"))

m <- leaflet(tbl)
m <- addTiles(m)
m <- with(tbl, addCircleMarkers(m, lng=long, lat=lat,
                                radius=dbh,
                                color=~pal(status),
                                fillColor=~pal(status),
                                fillOpacity=1
                                ))
m
