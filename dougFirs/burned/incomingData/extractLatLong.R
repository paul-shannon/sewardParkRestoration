library(plotKML)

f <- "Waypoints_17-OCT-20.gpx"
file.exists(f)
coi <- c("lon", "lat", "time", "name")
tbl <- readGPX(f)$waypoints[, coi]
colnames(tbl) <- c("lon", "lat", "time", "waypoint")
tbl
write.table(tbl, file="waypoint-17oct20.tsv", sep="\t", quote=FALSE, row.name=FALSE)

