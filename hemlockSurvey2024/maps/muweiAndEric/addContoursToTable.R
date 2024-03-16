library(jsonlite)
library(secr)
f <- "https://pshannon.net/hemlockSurvey2024/tblFinal.csv"
tbl <- read.table(f, sep=",", header=TRUE, as.is=TRUE, nrow=-1, quote="")
dim(tbl)  # 724 16

fb1 <- "gardenBoundaries.json"
fb2 <- "graveyardBoundaries.json"
tbl.garden <- fromJSON(fb1)
dim(tbl.garden)  # 949 2
tbl.graveyard <- fromJSON(fb2)
dim(tbl.graveyard) # 395 2

colnames(tbl.garden) <- c("y", "x")
tbl.garden <- tbl.garden[, c("x", "y")]

colnames(tbl.graveyard) <- c("y", "x")
tbl.graveyard <- tbl.graveyard[, c("x", "y")]


in.garden <- which(pointsInPolygon(tbl[, c("lon", "lat")], tbl.garden))  # 448
in.graveyard <- which(pointsInPolygon(tbl[, c("lon", "lat")], tbl.graveyard))  # 144
length(intersect(in.garden, in.graveyard))  # 0
location <- rep("none", nrow(tbl))
location[in.garden] <- "garden"
location[in.graveyard] <- "graveyard"
table(location)
tbl$loc <- location
hist(subset(tbl, loc=="garden")$h, subset(tbl, loc=="graveyard")$h)
head(tbl)
fivenum(subset(tbl, loc=="garden")$h)
fivenum(subset(tbl, loc=="graveyard")$h)
which(is.na(tbl$lat))
which(is.na(tbl$lon))
which(is.na(tbl$h)) # 359 360
tbl[which(is.na(tbl$h)),]
