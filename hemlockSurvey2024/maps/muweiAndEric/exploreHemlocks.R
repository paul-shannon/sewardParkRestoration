f <- "https://pshannon.net/hemlockSurvey2024/tblFinal.csv"
tbl <- read.table(f, sep=",", header=TRUE, as.is=TRUE, nrow=-1)
dim(tbl)

mapMidpoint  <- 47.556575

   # create two tables, one for the northern graveyard
   # one for the southern garden

tbl.north <- subset(tbl, lat >= mapMidpoint)
tbl.south <- subset(tbl, lat < mapMidpoint)
boxplot(tbl.north$h, tbl.south$h, names=c("graveyard", "garden"), main="Hemlock Health scaled 0-3")
boxplot(tbl.north$dbh, tbl.south$dbh, names=c("graveyard", "garden"), main="Hemlock Diameter (DBH inches)")

