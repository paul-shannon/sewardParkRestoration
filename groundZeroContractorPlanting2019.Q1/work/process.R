tbl <- read.table("table-raw.tsv", sep="\t", header=TRUE, as.is=TRUE)
tbl$common <- rownames(tbl)
rownames(tbl) <- NULL
coi <- c("binomial", "common", "symbol", "planted", "obs.2020.05.16")
tbl <- tbl[, coi]
write.table(tbl, file="record.tsv", sep="\t", quote=FALSE, row.names=FALSE)
tbl
