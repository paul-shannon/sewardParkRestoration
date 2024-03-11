tbl.old <- read.table("hemlocks-2021-clean.csv", sep=",", header=TRUE, nrow=-1, quote="")
dim(tbl.old)  # 116 15
wdth(80)
colnames(tbl.old)
colnames(tbl.old)[grep("wp", colnames(tbl.old))] <- "wpDamage"
colnames(tbl.old)[grep("dfAssociated", colnames(tbl.old))] <- "dfAssoc"

tbl.old$dfAssoc <- "False"
tbl.old$wpDamage <- 0
tbl.old$canopy <- "False"
tbl.old
tbl.old$observer[which(nchar(tbl.old$observer) == 0)] <- "all"

tbl.new <- read.table("hemlocks.csv", sep=",", header=TRUE)
dim(tbl.new)  # 469 15
colnames(tbl.new)

stopifnot(all(sort(colnames(tbl.new)) == sort(colnames(tbl.old))))
tbl.old <- tbl.old[, colnames(tbl.new)]

tbl.merged <- rbind(tbl.new, tbl.old)
dim(tbl.merged) # 585 15

write.table(tbl.merged, file="hemlocks-merged.csv", sep=",", row.names=FALSE, quote=FALSE)
