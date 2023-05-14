tbl <- read.table("finalReport-may-05-2023.tsv", sep="\t", header=TRUE)
names <- tbl$common
newData <- c("grand fir" = 1,
             "vine maple" = 3,
             "red alder" = 0,
             "oregon grape" = 0,
             "pacific dogwood" = 0,
             "beaked hazelnut" = 2,
             "salal" = 0,
             "indian plum" = 12,
             "baldhip rose" = 5,
             "scouler willow" = 0,
             "snowberry " = 38,
             "pacific yew" = 0,
             "foamflower" = 0,
             "hemlock" = 1,
             "huckleberry" = 19,
             "ocean spray" = 3)

tbl$obs.2023.05.05 <- as.integer(newData)
tbl.new <- tbl[, c(2, grep("obs", colnames(tbl)))]
