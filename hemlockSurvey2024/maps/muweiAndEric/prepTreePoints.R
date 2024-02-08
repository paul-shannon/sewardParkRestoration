options(digits=10)
library(jsonlite)
library(RColorBrewer)
#--------------------------------------------------------------------------------
toMarkerAndInfoWindow <- function(row)
{
   s0 <- "marker = new google.maps.Marker({"
   s1 <- sprintf("      position: {lat: %10.6f, lng: %10.6f}, ", row$lat, row$lon)
   s2 <- sprintf("      map, title: '%s',", row$id)
   s3 <- sprintf("      icon: %s", "defaultTreeMarker")
   s4 <- "      })"
   s <- sprintf("   %s\n%s\n%s\n%s\n%s", s0, s1, s2, s3, s4)

   iw0 <- "infoWindow = new google.maps.InfoWindow({"
   iw1 <- sprintf("       content: '%s'", row$id)
   iw2 <- "         })"
   iw <- sprintf("   %s\n%s\n%s", iw0, iw1, iw2)

   return(sprintf("%s\n%s", s, iw))

} # toMarker
#--------------------------------------------------------------------------------
tbl <- read.table("hemlocks.csv", sep=",", header=TRUE, as.is=TRUE, nrow=-1)
healthSums <- apply(tbl[, c("h1", "h2", "h3")], 1, sum, na.rm=TRUE)
goodValues <- apply(tbl[, c("h1", "h2", "h3")], 1, function(row) length(which(!is.na(row))))
overallHealth <- round(healthSums/goodValues, digits=2)
hist(overallHealth)
tbl$h <- overallHealth
preferredColumnOrder <- c("id","lat","lon","dbh","h1","h2","h3","h","aspect","slope","date","comments","observer")
tbl <- tbl[, preferredColumnOrder]
print(dim(tbl))
jsonText = toJSON(tbl, na="string", digits=6)
writeLines(jsonText, con="hemlocks.json")
printf("wrote %d lines to hemlock.json", nrow(tbl))
#for(i in 1:5)  # nrow(tbl))
#    writeLines(toMarkerAndInfoWindow(tbl[i,]))
#----------------------------------------------------------------------------------------------------
exploreColors <- function()
{
    colors <- rev(colorRampPalette(c("green", "lightgreen", "gray", "black"))(7))
    breaks <- c(0.5,1.0,1.5,2.0,2.5,3.0,3.5)

    plot(breaks, y=rep(10, length(breaks)), cex=8, xlim=c(0, 4), bg=colors,pch=21)

} # exploreColors
#--------------------------------------------------------------------------------
exploreContrasrts <- function()
{
   midpoint <- 47.556020
   dim(tbl)
   tbl.n <- subset(tbl, lat >= midpoint)
   tbl.s <- subset(tbl, lat < midpoint)
   boxplot(tbl.n$h, tbl.s$h, names=c("graveyard", "garden"), main="Hemlock Health scaled 0-3")
   boxplot(tbl.n$dbh, tbl.s$dbh, names=c("graveyard", "garden"), main="Hemlock Diameter (DBH inches)")

}
#--------------------------------------------------------------------------------
