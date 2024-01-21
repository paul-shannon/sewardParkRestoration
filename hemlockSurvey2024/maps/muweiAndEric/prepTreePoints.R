options(digits=10)

#--------------------------------------------------------------------------------
toMarker <- function(row)
{
   s0 <- "new google.maps.Marker({"
   s1 <- sprintf("      position: {lat: %10.6f, lng: %10.6f}, ", row$lat, row$lon)
   s2 <- sprintf("      map, title: '%s',", row$id)
   s3 <- sprintf("      icon: %s", "defaultTreeMarker")
   s4 <- "      })"
   s <- sprintf("   %s\n%s\n%s\n%s\n%s", s0, s1, s2, s3, s4)

    #  position: {lat: 47.560123, lng: -122.252269}, map, title: "1",
    #  icon: icon_1
    #  });

   return(s)

} # toMarker
#--------------------------------------------------------------------------------
tbl <- read.table("trees.csv", sep=",", header=TRUE, as.is=TRUE, nrow=-1)
for(i in 1:nrow(tbl))
    writeLines(toMarker(tbl[i,]))
