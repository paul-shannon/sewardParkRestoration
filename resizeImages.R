library(EBImage)
jpeg.files <- list.files(pattern="jpg$")

backup.directory <- "jpeg.originals"
if(!file.exists(backup.directory))
   dir.create(backup.directory)

for(file in jpeg.files){
   printf("before %40s: %d", file, file.info(file)$size)
   file.copy(file, file.path(backup.directory, file))
   }

for(file in jpeg.files){
    x <- readImage(file)
    x.small <- resize(x, 1024)
    writeImage(x.small, file, quality=50)
    printf("after  %40s: %d", file, file.info(file)$size)
    }
