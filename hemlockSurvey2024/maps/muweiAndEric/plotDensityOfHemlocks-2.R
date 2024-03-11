# see https://hohenfeld.is/posts/nicer-density-plots-with-ggplot2/
# for xy plotting of density, not on map
library(sf)
library(osmdata)
library(ggplot2)
library(ggpubr)
#--------------------------------------------------------------------------------
plotDensity <- function(tbl, title)
{
   tbl.loc <- tbl[, c("lat", "lon", "dbh")]
   missing <- which(is.na(tbl.loc$dbh))
   if(length(missing) > 0)
       tbl.loc <- tbl.loc[-missing,]
   repFactor = round(tbl.loc$dbh /12)+1
   #repFactor = round(tbl.loc$dbh)+1
   tbl.inflated <- data.frame()
   for(i in seq_len(nrow(tbl.loc))){
       tbl.inflated <- rbind(tbl.inflated, tbl.loc[rep(i, repFactor[i]),])
       }

   trees.sf <- st_as_sf(tbl.inflated, coords=c("lon", "lat"), crs=4326)
   trees.sf <- st_transform(trees.sf, 4326)

  x <- ggplot() +
      stat_density_2d(data = trees.sf,
                      mapping = aes(x = purrr::map_dbl(geometry, ~.[1]),
                                    y = purrr::map_dbl(geometry, ~.[2]),
                                    fill = stat(density)),
                      geom = 'tile',
                      contour = FALSE,
                      alpha = 0.8) +
       geom_sf(data = sf_seward, fill = NA) +
       # geom_sf(data = trees.sf, color="red") +
       scale_fill_viridis_c(option = 'magma', direction = -1) +
       theme_test() +
      ggtitle(title)

   return (x)

} # plotDensity
#--------------------------------------------------------------------------------
bottomLeft <- c(47.548233, -122.25676)
topRight   <- c(47.562744, -122.248006)
xMin <- bottomLeft[2]
xMax <- topRight[2]
yMin <- bottomLeft[1]
yMax <- topRight[1]

bbox <- c(xMin, yMin, xMax, yMax)

q <- opq(bbox=bbox)
sfData <- osmdata_sf(q)

   # bbox overpass_call meta osm_points osm_lines osm_polygons
   # osm_multilines osm_multipolygons

xLimits = c(xMin, xMax)
yLimits = c(yMin, yMax)

    # this is it! just seward

sf_seward <- st_geometry(sfData$osm_multilines)
sf_seward <- st_transform(sf_seward, 4326)

f <- "https://pshannon.net/hemlockSurvey2024/tblFinal.csv"
f <- "tblFinal.csv"
#f <- "hemlocks-merged.csv"
tbl <- read.table(f, sep=",", header=TRUE, as.is=TRUE, nrow=-1, quote="")


pdf(NULL)
quartz()

p.all <- plotDensity(tbl, "All Hemlocks")
p.sick <- plotDensity(subset(tbl, h <= 1),  "Hemlocks (h <= 1)")
p.healthy <- plotDensity(subset(tbl, h >= 2),  "Hemlocks (h >= 2)")

figure <- ggarrange(p.all, p.sick, p.healthy,nrow=1, ncol=3)

figure
