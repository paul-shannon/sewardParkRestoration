tbl <- read.table("hemlocks.csv", sep=",", header=TRUE, as.is=TRUE, nrow=-1)
tbl2 <- read.table("newColumns.csv", sep=",",header=TRUE, as.is=TRUE, nrow=-1)
stopifnot(all(colnames(tbl2) %in% colnames(tbl2)))
all(tbl2$id %in% tbl$id)


tbl.tmp <- subset(tbl, id %in% tbl2$id)
tbl.new <- merge(tbl, tbl2,by="id", all.x=TRUE)
   # move the comments column to the far end, for eacier reading
coi <- c("id","lat","lon","dbh","h1","h2","h3","aspect","slope","date","wpDamage.x","canopy.x","dfAssoc.x","observer","wpDamage.y","canopy.y","dfAssoc.y","comments")
tbl.new <- tbl.new[, coi]
   # some hand-editing needed, moving a few wpDamage.x, canopy.x, dfAssoc.x values to their .y equivalents
dim(tbl)      # 278 15
dim(tbl.new)  # 278 18
write.table(tbl.new, file="tblMerged.csv", sep=",", row.names=FALSE, quote=FALSE)

  # hand-editing complete-ish

tbl.merged <-read.table("tblMerged.csv", sep=",", header=TRUE, nrow=-1)
dim(tbl.merged)   # 278 18
tbl.merged

head(tbl.merged)

# missing canopy.y and dfAssoc.y now go to False

length(is.na(tbl.merged$canopy.x))

tbl.merged$dfAssoc.y[which(is.na(tbl.merged$dfAssoc.y))] <- "False"
tbl.merged$canopy.y[which(is.na(tbl.merged$canopy.y))] <- "False"
tbl.merged$wpDamage.y[which(is.na(tbl.merged$wpDamage.y))] <- 0

table(tbl.merged$dfAssoc.y)  # False  True
                             #  261    17
table(tbl.merged$canopy.y)   # False  True
                             #  258    20
table(tbl.merged$wpDamage.y) #   0   1   2   3   4   5
                             # 260   3   3   4   2   6

tbl.merged[209,"wpDamage.y"] <- 5
coi <- c("id","lat","lon","dbh","h1","h2","h3","aspect","slope","date","observer","wpDamage.y","canopy.y","dfAssoc.y","comments")
tbl.merged.final <- tbl.merged[, coi]
dim(tbl.merged.final)   # 278 15

   # remove the .y
coiNames <- coi <- c("id","lat","lon","dbh","h1","h2","h3","aspect","slope","date","observer","wpDamage","canopy","dfAssoc","comments")
colnames(tbl.merged.final) <- coiNames

write.table(tbl.merged.final, file="tblMergedFinal.csv", sep=",", row.names=FALSE, quote=FALSE)


coi
