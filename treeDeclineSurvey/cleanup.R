#f <- "tree-2.tsv"
f <- "tree-3.csv"
tbl <- read.table(f, sep=",", header=TRUE)
dim(tbl)
colnames(tbl)
colnames(tbl)[7] <- "dbh"
tbl$distance <- as.integer(sub("ft", "", tbl$distance))
tbl$direction <- as.integer(sub("°.*$", "", tbl$direction))
tbl$dbh <- as.numeric(sub("~", "", sub("ft", "", tbl$dbh)))

deleters <- grep("height", colnames(tbl))
if(length(deleters) > 0)
    tbl <- tbl[, -deleters]
tbl$status <- tolower(tbl$status)
healthy <- grep("healthy", tbl$status)
if(length(healthy) > 0)
    tbl <- tbl[-healthy,]

table(tbl$species)
write.table(tbl, file="trees3-clean.tsv", sep="\t", quote=FALSE, row.names=FALSE)
