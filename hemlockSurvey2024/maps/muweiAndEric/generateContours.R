library(MASS)
library(RColorBrewer)
library(jsonlite)
healthy.colors <- brewer.pal(10, "Greens")
healthy.colors[1] <- "#FFFFFF"
healthy.colors[10] <- "red"
sick.colors <- brewer.pal(8, "Reds")
sick.colors[1] <- "#FFFFFF"

f <- "https://pshannon.net/hemlockSurvey2024/tblFinal.csv"
tbl <- read.table(f, sep=",", header=TRUE, as.is=TRUE, nrow=-1, quote="")
dim(tbl)

seward.limits <- c(-122.25676, -122.248006, 47.548233, 47.562744) # from openstreetmap
cellCount <- 500
min.density <- 30000


tbl.h <- subset(tbl, h>=2) # | h <= 1)
f.healthy <- kde2d(tbl.h$lon, tbl.h$lat, n=cellCount, lims=seward.limits)
z <- f.healthy$z
range(z)
z[z <min.density] <- 0
f.healthy$z <- z
range(f.healthy$z)
image(f.healthy, main="healthy", col=healthy.colors) #, zlim = c(0, 0.05))
#dev.off()
contour(f.healthy, xlab = "healthy", add=TRUE)
contours.healthy <- contourLines(f.healthy)
length(contours.healthy)  # 9

tbl.s <- subset(tbl, h <= 1)
f.sick <- kde2d(tbl.s$lon, tbl.s$lat, n=cellCount, lims=seward.limits)
z <- f.sick$z
range(z)
z[z <min.density] <- 0
f.sick$z <- z
range(f.sick$z)
image(f.sick, main="sick", col=sick.colors) #, zlim = c(0, 0.05))
#dev.off()
contour(f.sick, xlab = "sick", add=TRUE)
contours.sick <- contourLines(f.sick)
length(contours.sick)  # 15



#--------------------------------------------------------------------------------
# create a JSON data structure that looks like this:
#  [{lat:  47.55686380, lng: -122.25135673},
#   {lat:  47.55686981, lng: -122.25135821},
#   {lat:  47.55689889, lng: -122.25136372}]
contourAsJSON <- function(rec)
{
    stopifnot(names(rec) == c("level", "x", "y"))

    iter.span <- seq_len(length(rec$x))
    json <- toJSON(lapply(iter.span,
                          function(i)list(lat=rec$y[i], lng=rec$x[i])),
                   auto_unbox=TRUE,
                   na="string", digits=6)
    json

} # contourAsJSON
#--------------------------------------------------------------------------------
level.h <- 1
contours.healthy[[level.h]]$level
jsonText = contourAsJSON(contours.healthy[[level.h]])
writeLines(jsonText, con="gardenBoundaries.json")

level.s <- 5
contours.sick[[level.s]]$level
jsonText = contourAsJSON(contours.sick[[level.s]])
writeLines(jsonText, con="graveyardBoundaries.json")

