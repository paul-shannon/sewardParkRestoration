tbl <- read.table("frondCounts.tsv", sep="\t", as.is=TRUE, header=TRUE)

y3.adzCounts <- as.integer(tbl[3, 3:14])
y3.gznCounts <- as.integer(tbl[6, 3:14])
y3.gzsCounts <- as.integer(tbl[7, 3:14])

adzMean <- sum(y3.adzCounts)/12
gzsMean <- sum(y3.gzsCounts)/12
gznMean <- sum(y3.gznCounts)/12

y4.adzCounts <- as.integer(tbl[4, 3:14])
y4.gznCounts <- as.integer(tbl[7, 3:14])
y4.gzsCounts <- as.integer(tbl[10, 3:14])


boxplot(y4.adzCounts, y4.gznCounts, y4.gzsCounts, main="Frond Counts May 2022 (50 months)", xlab="zone",
        ylab="fronds per fern", names=c("ADZ", "GZN", "GZS"))

boxplot(y3.adzCounts, y3.gznCounts, y3.gzsCounts, main="Frond Counts May 2021 (38 months)", xlab="zone",
        ylab="fronds per fern", names=c("ADZ", "GZN", "GZS"))

t.test(y3.adzCounts, c(y3.gzsCounts, y3.gznCounts))$p.value  # [1] 0.0008698714

table(y3.adzCounts)
table(y3.gznCounts)
table(y3.gzsCounts)

hist(y3.adzCounts, breaks=0:18)
hist(y3.gznCounts, breaks=0:18)
hist(y3.gzsCounts, breaks=0:18)

