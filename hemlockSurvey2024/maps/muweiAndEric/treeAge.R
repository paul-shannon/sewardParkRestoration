tbl <- read.table("tblFinal.csv", sep=",", header=TRUE, quote="", nrow=-1)
tbl.sub <- subset(tbl, loc=="garden" & h > 2.5)[, c("dbh", "h")]
dim(tbl.sub)
tbl.sub$cm <- tbl.sub$dbh * 2.54
boxplot(tbl.sub$cm)
plot(sort(tbl.sub$cm))
tbl.sub$age <- round(30.5 + (1.8 * tbl.sub$cm))
fivenum(tbl.sub$age)
tbl.sub$age2 <- jitter(tbl.sub$age, factor=3, amount =20)
with(tbl.sub, plot(age2, cm, main="Estimated Age", ylab="DBH (cm)", xlab="years"))
hist(tbl.sub$age2, main="Estimaged Age\n for 185 Healthy Hemlock Garden trees", xlab="years")
length(subset(tbl, loc=="garden" & h > 2.5)$dbh)
