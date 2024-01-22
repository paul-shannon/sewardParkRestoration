options(digits=10)
library(jsonlite)

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
toJSON(tbl, na="string")
#for(i in 1:5)  # nrow(tbl))
#    writeLines(toMarkerAndInfoWindow(tbl[i,]))
