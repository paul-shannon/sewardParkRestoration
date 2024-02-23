f <- "https://pshannon.net/hemlockSurvey2024/tblFinal.csv"
tbl <- read.table(f, sep=",", header=TRUE, as.is=TRUE, nrow=-1)
dim(tbl)
wdth(1000)
head(tbl)
# create lines like these to paste into function getPoints()
#    new google.maps.LatLng(37.782551, -122.445368),

printf("{location:  new google.maps.LatLng(%f, %f), weight: 10},", tbl$lat, tbl$lon)
wdth(100)
