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
assignGardenOrGraveyard <- function(tbl)
{
   library(secr)
   fb1 <- "gardenBoundaries.json"
   fb2 <- "graveyardBoundaries.json"
   tbl.garden <- fromJSON(fb1)
   printf("polygon vertices in %s: %d", fb1, nrow(tbl.garden))
   tbl.graveyard <- fromJSON(fb2)
   printf("polygon vertices in %s: %d", fb2, nrow(tbl.graveyard))

   colnames(tbl.garden) <- c("y", "x")
   tbl.garden <- tbl.garden[, c("x", "y")]

   colnames(tbl.graveyard) <- c("y", "x")
   tbl.graveyard <- tbl.graveyard[, c("x", "y")]


   in.garden <- which(pointsInPolygon(tbl[, c("lon", "lat")], tbl.garden))  # 448
   in.graveyard <- which(pointsInPolygon(tbl[, c("lon", "lat")], tbl.graveyard))  # 144
   location <- rep("none", nrow(tbl))
   location[in.garden] <- "garden"
   location[in.graveyard] <- "graveyard"
   printf("--- total trees, distribution within current contours")
   tbl$loc <- location
   print(table(tbl$loc))

   tbl

} # assignGardenOrGraveyard
#--------------------------------------------------------------------------------

f <- "hemlocks-merged.csv"
#f <- "hemlocks-tmp.csv"
tbl <- read.table(f, sep=",", header=TRUE, as.is=TRUE, nrow=-1,quote="")
#tbl.2021 <- read.table("hemlocks-2021-clean.csv", sep=",", header=TRUE, quote="")
#stopifnot(colnames(tbl) == colnames(tbl.2021))
#tbl <- rbind(tbl, tbl.2021)

  # big trees with a healthy canopy:  place extra value on h3 > 2
h3.2 <- tbl$h3
bigTreesWithHealthyCanopy <- which(tbl$dbh > 15 & tbl$h3 > 2)
length(bigTreesWithHealthyCanopy) # 89
tbl$h3.2 <- tbl$h3
tbl$h3.2[bigTreesWithHealthyCanopy] <- tbl$h3.2[bigTreesWithHealthyCanopy] + 1
healthSums <- apply(tbl[, c("h1", "h2", "h3.2")], 1, sum, na.rm=TRUE)
goodValues <- apply(tbl[, c("h1", "h2", "h3.2")], 1, function(row) length(which(!is.na(row))))
overallHealth <- round(healthSums/goodValues, digits=2)
hist(overallHealth)
tbl$h <- overallHealth
preferredColumnOrder <- c("id","lat","lon","dbh","h1","h2","h3","h","wpDamage", "canopy", "dfAssoc", "aspect","slope","date","comments","observer")
tbl <- tbl[, preferredColumnOrder]

tbl <- assignGardenOrGraveyard(tbl)

# tbl <- subset(tbl, date=="2024-02-10") # & observer=="paul")

write.table(tbl, "tblFinal.csv", sep=",", quote=FALSE, row.names=FALSE)
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
