
# email from louis (15 may 2023)
# {"SB":3.85,"SM1":2449.18,"SM2":328.07,"ST":23.81}
#
# SB: soil battery, approximately in volts
# SM1, SM2: soil moisture sensor 1,2. A range of about 2500-0,
#           lower number is wetter, we can calibrate and inter-calibrate
# ST: Temp in C, this should be very accurate as is.

library(jsonlite)
#--------------------------------------------------------------------------------
table.from.files <- function()
{
    files <- sort(dir(pattern="*.json"))  # in increasing time order
    tbls <- list()

    for(file in files){
       suppressWarnings({json <- readLines(con=file)})
       tbl.raw <- fromJSON(json, flatten=TRUE)
       #tbl <- tbl.raw$body
       #coi <- c("received", grep("body.S", colnames(tbl.raw), v=TRUE))
       head(tbl.raw[, coi])
       head(subset(tbl.raw[, coi], !is.na(body.SB)))
       tbl <- subset(tbl.raw[, coi], !is.na(body.SB))
       colnames(tbl) <- sub("body.", "", colnames(tbl), fixed=TRUE)
       new.order <- rev(seq_len(nrow(tbl)))
       tbl <- tbl[new.order,]
       tbl$SM1 <- 2500 - tbl$SM1
       tbl$SM2 <- 2500 - tbl$SM2
       epoch.times <- tbl$received
       human.times <- as.POSIXlt(epoch.times, origin = "1970-01-01")
       format <- "%m-%d %H:%M"
       timestamps <- strftime(human.times, format=format)
       tbl$timestamp <- timestamps
       tbls[[file]] <- tbl
       }

    tbl <- do.call(rbind, tbls)
    dups <- which(duplicated(tbl$received))
    if(length(dups) > 0)
        tbl <- tbl[-dups,]
    tbl

} # table.from.files
#--------------------------------------------------------------------------------
tbl <- table.from.files()

date.range <- sprintf("from %s to %s", head(tbl$timestamp, n=1), tail(tbl$timestamp, n=1))
plot(tbl$received, tbl$SM1, xaxt="n", , ylim=c(0,2500), type="l",
     col="darkblue", xlab="time", ylab="moisture",
     main=sprintf("Seward Soil Moisture %s", date.range))
lines(tbl$received, tbl$SM2, col="darkgreen")
min.x <- min(tbl$received)
max.x <- max(tbl$received)
delta.x <- max.x - min.x
x <- min.x + 0.98 * delta.x
legend(x, 2550, c("SM1", "SM2"), c("darkblue", "darkgreen"))

# plot temperature
# plot(tbl$received, tbl$ST)

# f1 <- "data-2023-05-30T23_34_12Z.json"
# f1 <- rev(sort(dir(pattern="*.json")))[1]
# json <- readLines(con=f1)
# tbl.raw <- fromJSON(json, flatten=TRUE)
# dim(tbl.raw)  # 340 65
#
# tbls <- tbl.raw$body
# coi <- c("received", grep("body.S", colnames(tbl.raw), v=TRUE))
# head(tbl.raw[, coi])
# head(subset(tbl.raw[, coi], !is.na(body.SB)))
# tbl <- subset(tbl.raw[, coi], !is.na(body.SB))
# colnames(tbl) <- sub("body.", "", colnames(tbl), fixed=TRUE)
#
# # put in time order.  currently has latest entry first
# new.order <- rev(seq_len(nrow(tbl)))
# tbl <- tbl[new.order,]
# tbl$SM1 <- 2500 - tbl$SM1
# tbl$SM2 <- 2500 - tbl$SM2
#
# epoch.times <- tbl$received
# human.times <- as.POSIXlt(epoch.times, origin = "1970-01-01")
#
# format <- "%m-%d %H:%M"
# format <- "%H:%M"
# timestamps <- strftime(human.times, format=format)
# head(timestamps)
# tbl$timestamp <- timestamps
# date.range <- sprintf("from %s to %s", head(tbl$timestamp, n=1), tail(tbl$timestamp, n=1))
# plot(tbl$received, tbl$SM1, xaxt="n", , ylim=c(0,2500), type="l",
#      col="darkblue", xlab="time", ylab="moisture",
#      main=sprintf("Seward Soil Moisture %s", date.range))
# lines(tbl$received, tbl$SM2, col="darkgreen")
# min.x <- min(tbl$received)
# max.x <- max(tbl$received)
# delta.x <- max.x - min.x
# x <- min.x + 0.98 * delta.x
# legend(x, 2550, c("SM1", "SM2"), c("darkblue", "darkgreen"))
#
#  # axis.Date(1, at=tbl$timestamp)
#  # axis.Date(1, at=tbl$timestamp,labels=format(tbl$timestamp,format),las=2)
#  # axis.Date(1, at=tbl$timestamp,labels=format(tbl$timestamp,format),las=2)
#  #
#  # # as.Date(as.POSIXct(tbl$received[1], origin = "1970-01-01"))
#  # strptime(df$timestamp, "%Y-%m-%dT%H:%M:%S"))
#  #
#  # epoch.time <- tbl$received[1]
#  # human.time <- as.POSIXlt(epoch.time, origin = "1970-01-01")
#  # print(human.time) # "2023-05-30 16:17:21 PDT"
#
#
#
# #as.Date(human.time,
# #strptime(human.time, "%Y-%m-%dT%H:%M:%S"))
# #
# #   _env.dbs  _health.qo     _log.qo _session.qo     data.qo
# #         28          25           1          99         103
#
#  # tbl.body0 <- tbl.raw0$body
#  # dim(tbl.body0)   # 170 39
#  #
#  # tbl.body1 <- tbl.raw1$body
#  # dim(tbl.body1)   # 170 39
#  #
#  # dim(subset(tbl.02, !is.na(SB)))  # Soil Battery
#  # tbl0 <- subset(tbl.02, !is.na(SB))[, 2:5]
#  # head(tbl)
#  # dim(tbl)
#  # plot(tbl$SM1, ylim=c(0, 2500), type="b")
#  # lines(tbl$SM2, type="b")
#  # wdth(20); colnames(tbl.2)
#  #  #  [1] "event"
#  #  #  [2] "session"
#  #  #  [3] "best_id"
#  #  #  [4] "device"
#  #  [5] "product"
#  #  [6] "app"
#  #  [7] "received"
#  #  [8] "req"
#  #  [9] "when"
#  # [10] "file"
#  # [11] "body"
#  # [12] "best_location_type"
#  # [13] "best_location_when"
#  # [14] "best_lat"
#  # [15] "best_lon"
#  # [16] "best_location"
#  # [17] "best_country"
#  # [18] "best_timezone"
#  # [19] "tower_when"
#  # [20] "tower_lat"
#  # [21] "tower_lon"
#  # [22] "tower_country"
#  # [23] "tower_location"
#  # [24] "tower_timezone"
#  # [25] "tower_id"
#  # [26] "moved"
#  # [27] "orientation"
#  # [28] "rssi"
#  # [29] "sinr"
#  # [30] "rsrp"
#  # [31] "rsrq"
#  # [32] "rat"
#  # [33] "bars"
#  # [34] "voltage"
#  # [35] "temp"
#  # [36] "fleets"
#  # [37] "tls"
#  # [38] "note"
#  # [39] "updates"
#  # [40] "endpoint"
#
#  # fivenum(as.numeric(tbl.2$when))     #  1683413873 1683514820 1683527760 1683542728 1683995003.  span: 581130
#  # fivenum(tbl.2$sinr)     #  8.0  81.5  89.0  94.0 106.0
#  # fivenum(tbl.2$rssi)     # -125  -67  -66  -64  -59
#  # fivenum(tbl.2$sinr)     #  8.0  81.5  89.0  94.0 106.0
#  # fivenum(tbl.2$rsrp)     # -140  -96  -95  -95  -90
#  # fivenum(tbl.2$rsrq)     # -20 -17 -16 -15  -3
#  # fivenum(tbl.2$bars)     #  1 2 2 2 3
#  # fivenum(tbl.2$voltage)  #  3.2750 4.8150 4.8170 4.8275 5.0290
#  # fivenum(tbl.2$temp)     #  14.250 14.906 16.250 18.812 22.125
#  #
#  #
#  #  #------------------------------------------------------
#  #  # look at the numeric columns
#  #  #------------------------------------------------------
#  #
#  # numeric.columns <- names(which(lapply(tbl.2, class) != "character"))
#  # for(col in numeric.columns){
#  #    printf("--- %s", col)
#  #    print(fivenum(as.numeric(tbl.2[, col], na.rm=TRUE)))
#  #    }
#  #
