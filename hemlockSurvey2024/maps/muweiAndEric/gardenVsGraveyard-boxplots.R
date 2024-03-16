f <- "https://pshannon.net/hemlockSurvey2024/tblFinal.csv"
f <- "tblFinal.csv"
f <- "hemlocks-merged.csv"
tbl <- read.table(f, sep=",", header=TRUE, as.is=TRUE, nrow=-1, quote=NULL)
table(tbl$loc)
dim(tbl)
boxplot(subset(tbl, loc=="graveyard")$h,
        subset(tbl, loc=="garden")$h,
        main="Hemlock Health (0-4)",
        names=c("Graveyard", "Garden"))

par(mfrow=c(1,2))
hist(subset(tbl, loc=="garden")$dbh, ylim=c(0,130), xlim=c(0,60),main="Garden DBH")
hist(subset(tbl, loc=="graveyard")$dbh, ylim=c(0,130), xlim=c(0,60), main="Graveyard DBH")

quartz()
par(mfrow=c(1,1))
dbh.threshold <- 10
boxplot(subset(tbl, loc=="graveyard" & dbh > dbh.threshold)$dbh,
        subset(tbl, loc=="garden" & dbh > dbh.threshold)$dbh,
        main="Age (DBH proxied) youngest trees omitted",
        names=c("Graveyard", "Garden"))

boxplot(subset(tbl, loc=="graveyard" & dbh > dbh.threshold)$h,
        subset(tbl, loc=="garden" & dbh > dbh.threshold)$h,
        main="Health youngest trees omitted",
        names=c("Graveyard", "Garden"))

dbh.threshold <- 10
garden.bigTrees.dbh <- subset(tbl, loc=="garden" & dbh > dbh.threshold)$dbh
graveyard.bigTrees.dbh <- subset(tbl, loc=="graveyard" & dbh > dbh.threshold)$dbh

t.test(graveyard.bigTrees.dbh, garden.bigTrees.dbh)$p.value

garden.bigTrees.health <- subset(tbl, loc=="garden" & dbh > dbh.threshold)$h
graveyard.bigTrees.health <- subset(tbl, loc=="graveyard" & dbh > dbh.threshold)$h

t.test(graveyard.bigTrees.health, garden.bigTrees.health)$p.value


