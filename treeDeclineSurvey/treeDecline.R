library(yaml)
options(digits=12)
degrees.per.radian <- 57.2958
feet.per.lat.degree <- 364320
feet.per.lon.degree <- 245520   # at seattle's latitude of 47.5

#f <- "treeDecline.tsv"
#f <- "trees3-clean.tsv"
#f <- "trees-day2-clean.tsv"
#tbl <- read.table("treeDecline.tsv", header=TRUE, sep="\t")
f <- "treeDecline-final--clean.tsv"
tbl <- read.table(f, header=TRUE, sep="\t")
tbl$latCorrected <- rep(0, nrow(tbl))
tbl$lonCorrected <- rep(0, nrow(tbl))
dim(tbl)

for(r in seq_len(nrow(tbl))){
    lat <- tbl$lat[r]
    lon <- tbl$lon[r]
    direction <- tbl$direction[r]
    distance <- tbl$distance[r]
    #browser()
    printf("%d: %10.6f %10.6f %8d %8d", r, lat, lon, direction, distance)
    lat.delta <- distance * sin(direction/degrees.per.radian)/feet.per.lat.degree
    lon.delta <- distance * cos(direction/degrees.per.radian)/feet.per.lon.degree
    tbl$latCorrected[r] <- lat + lat.delta
    tbl$lonCorrected[r] <- lon + lon.delta
    }

for(r in seq_len(nrow(tbl))){
   name <- sprintf("%s.%s.%04d", tbl$species[r], "decline", r)
   observer <- "ISB.esore"
   id <- name
   group <- sprintf("%s.decline.assay", tbl$species[r])
   date <- tbl$date[r]
   lat <- tbl$latCorrected[r]
   lon <- tbl$lonCorrected[r]
   vitality <- with(tbl[r,], low + mid + high) # 0-9
   colors <- rev(colorRampPalette(c("green", "black"))(10))
   color <- colors[vitality+1]
   #printf("%d", r)
   radius <- tbl$dbh[r] * 2
   details <- tbl$status[r]
   yaml <- as.yaml(list(name=name,
                        observer=observer,
                        id=id,
                        group=group,
                        date=date,
                        lat=lat,
                        lon=lon,
                        color=color,
                        radius=radius,
                        details=details))
   write(yaml, file="trees.yaml", append=TRUE)
   }
