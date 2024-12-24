library(geosphere)
options(digits=10)
#--------------------------------------------------------------------------------
toLatLon <- function(plotNumber, angle, distanceInFeet)
{

  centerLon = subset(tbl.plots, plot==plotNumber)$lon
  centerLat = subset(tbl.plots, plot==plotNumber)$lat
  center <- c(centerLon, centerLat)

  distanceInMeters = distanceInFeet/3.28084
  destPoint(center, angle, distanceInMeters)

}
#--------------------------------------------------------------------------------
test_toLatLon <- function()
{
   plotCenter = c(-122.25246, 47.55374)
   loc <- toLatLon(plotCenter, 119, 43.5)
          destPoint(pc, 119, 43.5/3.25)

} # test_toLatLon
#--------------------------------------------------------------------------------
tbl <- read.table("fia.csv", sep=",", header=TRUE, fill=TRUE, nrow=-1, comment="!")
dim(tbl) # 357 18
colnames(tbl)
stopifnot(all(is.na(tbl$u2)))
stopifnot(all(is.na(tbl$u3)))
tbl <- tbl[, -c(17,18)]
dim(tbl)
colnames(tbl) <- tolower(colnames(tbl))
table(tbl$species)
table(tbl$plot)

tbl.plots = read.table("plots.csv", header=TRUE, sep=",")

plot.oi <- 1
plot.center.lat <- subset(tbl.plots, plot==plot.oi)$lat
plot.center.lon <- subset(tbl.plots, plot==plot.oi)$lon

coi <- c("plot", "tree", "az", "dist",  "status", "species",  "dbh",  "ht")
#tbl.trees <- subset(tbl, plot==plot.oi)[,coi]
tbl.trees <- tbl

lon <- vector(mode="numeric", length=nrow(tbl.trees))
lat <- vector(mode="numeric", length=nrow(tbl.trees))

for (r in 1:nrow(tbl.trees)){
    x <- toLatLon(tbl.trees$plot[r],  tbl.trees$az[r], tbl.trees$dist[r])
    lon[r] <- as.numeric(x[1, 'lon'])
    lat[r] <- as.numeric(x[1, 'lat'])
    printf("r: %d   %f   %f", r, lon[r], lat[r])
    }
rownames(tbl.trees) <- NULL
tbl.trees$lat <- lat
tbl.trees$lon <- lon
dim(tbl.trees)  # 20 8

tbl.trees <- tbl.trees[order(tbl.trees$tree),]
final.coi <- c("plot", "tree", "lat", "lon",  "species",  "dbh", "ht",  "status")
tbl.trees <- tbl.trees[, final.coi]

write.table(tbl.trees, file="trees.tsv", sep="\t", quote=FALSE, row.names=FALSE)

