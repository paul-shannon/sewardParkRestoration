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
tbl <- read.table("trees.csv", sep=",", header=TRUE, as.is=TRUE, nrow=-1)
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
