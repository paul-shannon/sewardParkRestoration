#  - name: hemlockDecline.001
#    observer: Paul
#    id: waypoint.140
#    group: Hemlock Decline
#    date: 2021-07-05
#    lat:  47.55835
#    lon: -122.25080
#    color: black
#    radius: 3
#    details: http://pshannon.net/sewardParkRestoration/hemlocks/hemlock.001
#
#----------------------------------------------------------------------------------------------------
toStandardForm <- function(tbl.in)
{
    tbl.in$group <- "Hemlock Decline"
    health <- rowSums(tbl[, c("dmr1", "dmr2", "dmr3")])
    colors <-  colorRampPalette(c("green", "black"))(7)  # "#00FF00" "#00D400" "#00AA00" "#007F00" "#005500" "#002A00" "#000000"
    missing.colors <- which(health < 0)
    health[health < 0] <- 0
    color.values <- colors[health+1]
    tbl.in$color <- color.values
    tbl.in$color[missing.colors] <- "red"
    tbl.in$details <- "http://pshannon.net/sewardParkRestoration/hemlocks"

    coi <- c("id", "observer", "gpsID", "group", "date", "lat", "lon", "color", "dbh", "details")
    tbl.out <- tbl.in[, coi]
    colnames(tbl.out)[1] <- "name"
    colnames(tbl.out)[3] <- "id"
    colnames(tbl.out)[9] <- "radius"

    radii <- round(sqrt(tbl$dbh)) # - 1
    radii[radii==0] <- 1
    tbl.out$radius <- radii
    tbl.out$id <- sprintf("waypoint.%s", tbl.out$id)
    tbl.out$details <- "NA"

    tbl.out

} # toStandardForm
#----------------------------------------------------------------------------------------------------
library(yaml)
tbl <- read.table("hemlocks.tsv", sep="\t", as.is=TRUE, header=TRUE, quote="")
tbl.ready <- toStandardForm(tbl)
head(tbl.ready)
write_yaml(tbl.ready, file="tmp.yaml", column.major=FALSE, indent=4)
