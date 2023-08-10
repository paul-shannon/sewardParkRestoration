#f <- "tree-2.tsv"
#f <- "tree-3.csv"
options(digits=12)
f <- "treeDecline-day2.csv"
f <- "treeDecline-final.csv"
tbl <- read.table(f, sep=",", header=TRUE)
dim(tbl)
colnames(tbl)
#colnames(tbl)[7] <- "dbh"
#tbl$distance <- as.integer(sub("ft", "", tbl$distance))
#tbl$direction <- as.integer(sub("°.*$", "", tbl$direction))
#tbl$dbh <- as.numeric(sub("~", "", sub("ft", "", tbl$dbh)))

#deleters <- grep("height", colnames(tbl))
#if(length(deleters) > 0)
#    tbl <- tbl[, -deleters]
tbl$status <- tolower(tbl$status)
table(tbl$status)
tbl$species <- tolower(tbl$species)
table(tbl$species)
tbl$distance <- as.integer(round(tbl$distance))
fivenum(tbl$distance)  #   4  13  28  49 160

bad.lat <- which(tbl$lat == 47.0)
bad.lon <- which(tbl$lon == 122.0)

bad.pos <- unique(c(bad.lat, bad.lon))
if(length(bad.pos) > 0)
    tbl <- tbl[-bad.pos,]
dim(tbl)
tbl$lon <- -1 * abs(tbl$lon)

suppressWarnings(
    bad.dbh <- which(is.na(as.integer(tbl$dbh) == 0))
    )
tbl$dbh <- as.numeric(tbl$dbh)
write.table(tbl, file="treeDecline-final--clean.tsv", sep="\t", quote=FALSE, row.names=FALSE)
