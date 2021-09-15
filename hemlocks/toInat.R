tbl <- read.table("hemlocks.tsv", sep="\t", as.is=TRUE, header=TRUE, quote="", nrows=-1)

# Taxon name	Date observed	  Description	Place name	Latitude / y coord / northing	Longitude / x coord / easting	Tags	Geoprivacy
#       text	YYYY-MM-DD HH:MM	 text	      text	                      dd.dddd	                      dd.dddd	tag,tag	  obscured

tbl[, "Taxon name"] <- "Tsuga heterophylla"
tbl[, "Place name"]  <- "Seward Park, Seattle"
tbl[, "Tags"] <- ""
tbl[, "Geoprivacy"] <- "open"
tbl[, "Description"] <- sprintf("%s, GPS %d", tbl$id, tbl$gpsID)

deleters <-
   match(c("firstDead", "firstLive", "id", "gpsID", "observer", "notes"), colnames(tbl))

tbl <- tbl[, -deleters]

col.order <- c("Taxon name", "date", "Description", "Place name", "lat", "lon", "Tags", "Geoprivacy", "height", "dbh", "dmr1", "dmr2", "dmr3")
setdiff(col.order, colnames(tbl))
tbl <- tbl[, col.order]

coi <- c("Taxon name",
         "Date observed",
         "Description",
         "Place name",
         "Latitude / y coord / northing",
         "Longitude / x coord / easting",
         "Tags",
         "Geoprivacy",
         "Estimated Height of Tree (ft)",
         "DBH (inches)",
         "DMR.1", "DMR.2", "DMR.3")
ncol(tbl)
length(coi)
stopifnot(ncol(tbl) == length(coi))
colnames(tbl) <- coi
dim(tbl)
head(tbl)
write.table(tbl, sep=",", row.names=FALSE, file="inat-upload-all.csv")

# Observation file has been queued for import.

# coi <- c("date", "lat", "lon", "height", "dbh", "dmr1", "dmr2", "dmr3")
# setdiff(coi, colnames(tbl))
#
# tbl.out <- tbl[2:4, coi]
# tbl.out$id <- "Western Hemlock"
# tbl.out$user_id <- "paul-shannon"
#
# coi.final.order <- c("id", "date", "user_id", "lat", "lon", "height", "dbh", "dmr1", "dmr2", "dmr3")
# setdiff(coi.final.order, colnames(tbl.out))
# tbl.out <- tbl.out[, coi.final.order]
#
# coi.final <- c("Taxon name", "Date observed", "Description", "Place name" "Latitude", "Longitute", "Tags", "Geoprivacy")
#
# "user_id", "lat", "lon", "Estimated Height of Tree (ft)", "DBH (inches)", "DMR.1", "DMR.2", "DMR.3")
# colnames(tbl.out) <- coi.final
# write.table(tbl.out, sep=",", row.names=FALSE, file="inat-upload-2-4.csv")
# class(tbl.out$lat)
#
#
# id,observed_on_string,observed_on,time_observed_at,time_zone,user_id,user_login,created_at,updated_at,quality_grade,license,url,image_url,sound_url,tag_list,description,num_identification_agreements,num_identification_disagreements,captive_cultivated,oauth_application_id,place_guess,latitude,longitude,positional_accuracy,private_place_guess,private_latitude,private_longitude,public_positional_accuracy,geoprivacy,taxon_geoprivacy,coordinates_obscured,positioning_method,positioning_device,species_guess,scientific_name,common_name,iconic_taxon_name,taxon_id

# A hash mark at the start of a row will mean the entire row is ignored
#Lorem,2013-01-01,Description of observation,Wellington City,47.554583,-122.249883,"Comma,Separated",[Leave blank for 'open'],"One of Healthy, Branch Tip Dieback, Individual Branches Dying or 'Flagging', Needle Cast (unusual drop of needles), Web Blight, Woolly Adelgid Present, Thinning Canopy (extra see through), Yellowing Canopy, Extra Cone Crop, Browning Canopy, Dead Top, Multiple Symptoms (please list in Notes), Tree is dead, Other (please describe in Notes)","One of Healthy, no dieback(0%), 1-29% of the canopy is unhealthy, 30-59% of the canopy is unhealthy, 60-99% of the canopy is unhealthy, tree is dead",numeric
# Ipsum,2013-01-01 09:10:11,,,,,"List,Of,Tags",Private,,,
# Dolor,2013-01-01T14:40:33,,,,,,Obscured,,,

