tbl <- read.table("finalReport-jul-06-2021.tsv", sep="\t", header=TRUE, as.is=TRUE, nrow=-1)
obs.2022.05.22 <- c("grand fir"=0,
  "vine maple"=1,
  "red alder"=0,
  "oregon grape"=2,
  "pacific dogwood"=0,
  "beaked hazelnut"=1,
  "salal"=0,
  "indian plum"=10,
  "baldhip rose"=7,
  "scouler willow"=0,
  "snowberry "=46,
  "pacific yew"=0,
  "foamflower"=0,
  "hemlock"=1,
  "huckleberry"=24,
  "ocean spray"=5
  )

tbl <- cbind(tbl, obs.2022.05.22)
coi <- c("binomial",
         "common",
         "symbol",
         "planted",
         "obs.2020.05.16",
         "obs.2021.05.29",
         "obs.2022.05.22",
         "percentSurvival",
         "notes")
tbl <- tbl[, coi]
colnames(tbl)[8] <- "pcs.2021"
pcs.2022 <- with(tbl, round(100*obs.2022.05.22/planted))
tbl <- cbind(tbl, pcs.2022)

coi <- c("binomial",
         "common",
         "symbol",
         "planted",
         "obs.2020.05.16",
         "obs.2021.05.29",
         "obs.2022.05.22",
         "pcs.2021",
         "pcs.2022")
#         "notes")
tbl <- tbl[, coi]
rownames(tbl) <- NULL
tbl

