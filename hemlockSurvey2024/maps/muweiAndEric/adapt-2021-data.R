tbl <- read.table("~/github/sewardParkRestoration/hemlockSurvey2021/hemlocks.tsv", sep="\t", as.is=TRUE, quote=NULL, header=TRUE)
dim(tbl)
wdth(400)
colnames(tbl)
x <- tbl[, c("id","lat","lon","dbh","dmr1","dmr2","dmr3","date","observer","notes")]
# dmrN is on scane of 0:2, with 0 being fully healthy.  convert to 0:3 scale we use in 2024
# 0 -> 3
# 2 >- 0
# 1 > 1.5

x$h1 <- NA
x$h2 <- NA
x$h3 <- NA

x$h1[x$dmr1 == 0] <- 3
x$h1[x$dmr1 == 2] <- 0
x$h1[x$dmr1 == 1] <- 1.5

x$h2[x$dmr2 == 0] <- 3
x$h2[x$dmr2 == 2] <- 0
x$h2[x$dmr2 == 1] <- 1.5

x$h3[x$dmr3 == 0] <- 3
x$h3[x$dmr3 == 2] <- 0
x$h3[x$dmr3 == 1] <- 1.5

coi <- c("id", "lat", "lon", "dbh",  "h1", "h2", "h3", "date", "observer", "notes")
x <- x[, coi]

x$id <- sub("hemlock.", "2021-", x$id, fixed=TRUE)
x$aspect <- NA
x$slope <- NA
x$wp <- NA
x$canopy <- NA
x$dfAssociated <- NA

colnames(x)
colnames(x)[grep("notes", colnames(x))] <- "comments"
coi <- c("id","lat","lon","dbh","h1","h2","h3","aspect","slope","date","comments","wp","canopy","dfAssociated","observer")
setdiff(colnames(x), coi)
x <- x[, coi]
write.table(x, file="hemlocks-2021-clean.csv", sep=",", row.names=FALSE, quote=FALSE)

