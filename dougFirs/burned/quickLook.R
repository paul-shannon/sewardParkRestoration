dir(path="incomingData") # [1] "2020-jun-27.csv"
tbl <- read.table("incomingData/2020-jun-27.csv", sep=",", as.is=TRUE, header=TRUE, nrow=-1)
dim(tbl)

tbl$lat <- as.numeric(sub("°", "", tbl$Latitude))
tbl$lon <- as.numeric(sub("°", "", tbl$Longitude))

plot(tbl$lon, tbl$lat)


