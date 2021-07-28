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
    tbl.in$color <- "black"
    tbl.in$details <- "http://pshannon.net/sewardParkRestoration/hemlocks"

    coi <- c("id", "observer", "gpsID", "group", "date", "lat", "lon", "color", "dbh", "details")
    tbl.out <- tbl.in[, coi]
    colnames(tbl.out)[1] <- "name"
    colnames(tbl.out)[3] <- "id"
    colnames(tbl.out)[9] <- "radius"

    tbl.out$radius <- 3
    tbl.out$id <- sprintf("waypoint.%s", tbl.out$id)
    tbl.out$details <- sprintf("%s/%s", tbl.out$details, tbl.out$name)

    tbl.out

} # toStandardForm
#----------------------------------------------------------------------------------------------------
library(yaml)
tbl <- read.table("hemlocks.tsv", sep="\t", as.is=TRUE, header=TRUE, quote="")
tbl.ready <- toStandardForm(tbl)
head(tbl.ready)
write_yaml(tbl.ready, file="tmp.yaml", column.major=FALSE, indent=4)
