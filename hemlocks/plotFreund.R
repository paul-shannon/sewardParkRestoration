library(randomcoloR)
randomColors <- distinctColorPalette(9)
tbl <- read.table("freundFranklinLutzHemlockStats.tsv", sep="\t", as.is=TRUE, header=TRUE, comment="#", nrow=-1)
dim(tbl)
sizes <- round(tbl$mean.dbh.inches/3)
plot(tbl$stand.age, tbl$density, cex=sizes, ylim=c(0, 300), xlim=c(0, 400), col=randomColors, pch=16,
     xlab="Stand Age (oldest fir)", ylab="Site Density (hemlocks/hectare)",
     main="Stand Density of Hemlocks Increases Over Time")
legend(x=10, y=300, tbl$site, randomColors)

subset(tbl, mean.dbh.inches < 11)

quartz()

sizes <- round(tbl$max.dbh.inches/5)
sizes <- 5
plot(tbl$stand.age, tbl$mean.dbh.inches, cex=sizes, ylim=c(5, 20), xlim=c(0, 400), col=randomColors, pch=16,
     xlab="Stand Age (oldest fir)", ylab="Mean DBH (inches)",
     main="Average DBH Increases Over Time")
legend(x=10, y=20, tbl$site, randomColors)
