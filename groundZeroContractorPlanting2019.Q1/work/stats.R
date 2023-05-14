tbl <- read.table("record.tsv", sep="\t", header=TRUE, as.is=TRUE)

tbl$percentSurvival <- sprintf("%d", round(100 * tbl[, 6]/tbl[,4],digits=0))

write.table(tbl, file="tbl-2021-final.tsv", sep="\t", row.names=FALSE, col.names=TRUE, quote=FALSE)
