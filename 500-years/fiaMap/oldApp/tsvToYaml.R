# tsvToYaml.R
library(RColorBrewer)
tbl <- read.table("../trees.tsv", sep="\t", as.is=TRUE, header=TRUE)
dim(tbl)
species <- sort(unique(tbl$species))
speciesCount <- length(species)
printf("speciesCount: %d", speciesCount)
colors <- c("Big Leaf Maple"="darkgreen",
            "Douglas Fir"="green",
            "Western Red Cedar"="lightgreen",
            "Pacific Madrone"="gray",
            "Western Hemlock"="darkgray",
            "Red Alder"="red",
            "Yew"="black",
            "Norway Maple"="yellow",
            "Coastal Redwood"="blue",
            "Cherry"="turquoise",
            "Cascara"="magenta")

#------------------------------------------------------------------------------------------
speciesToColor <- function(species)
{
    return(colors[[species]])
   # switch(species,
   #        "Douglas Fir"="green",
   #        "Big Leaf Maple"="blue",
   #        "Western Red Cedar"="yellow",
   #        "Cherry"="red",
   #        "black")

} # speciesToColor
#------------------------------------------------------------------------------------------
toYaml <- function(tbl, row)
{
    name <-     sprintf("   - name: FIA-%d-%d", tbl[row, "plot"], tbl[row, "tree"])
    id <-       sprintf("     id: FIA-%d-%d", tbl[row, "plot"], tbl[row, "tree"])
    observer <- sprintf("     observer: Butcher, Billo")
    group  <-   sprintf("     group: %s", tbl[row, "species"])
    date <-     sprintf("     date: summer 2024")
    lat  <-     sprintf("     lat: %15.8f", tbl[row, "lat"])
    lon  <-     sprintf("     lon: %15.8f", tbl[row, "lon"])
    color <-    sprintf("     color: %s", speciesToColor(tbl[row, "species"]))
    dbh   <-    sprintf("     dbh: %f", tbl[row, "dbh"])
    radius <-   as.integer(tbl[row, "dbh"]/3)
    radius <-   sprintf("     radius: %d", radius)
    details <-  sprintf("     details: NA")

    for(line in c(name, id, observer, group, date, lat, lon, color, dbh, radius, details))
        print(noquote(line))
    print(noquote(""))

}
#------------------------------------------------------------------------------------------
for (row in 1:nrow(tbl)) toYaml(tbl,row)

