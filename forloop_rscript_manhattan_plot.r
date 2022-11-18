.libPaths( c( .libPaths(), "/global/home/hpc4094/R/x86_64-pc-linux-gnu-library/3.4/") )
.libPaths( c( .libPaths(), "/global/home/hpc4094/R/x86_64-pc-linux-gnu-library/3.5/") )
.libPaths( c( .libPaths(), "/global/home/hpc4094/R/x86_64-redhat-linux-gnu-library/3.3/") )


setwd("/your/path")

library(dplyr)
library(qqman)




################################################
#Plotting in loop
files <- list.files(path="/your/path", pattern=".assoc.linear", full.names = F, recursive = F)


for (i in 1:length(files)){
  res10 <- read.table(files[i], header = T, stringsAsFactors = F)
  res11 <- res10 %>% 
    filter(TEST == 'ADD')
  ylim <- abs(floor(log10(min(res11$P)))) + 2
  png(filename = paste(gsub("metabolite\\.|name\\_|.assoc.linear","", files[i]),'manhattan_multi','png', sep="."), width = 8, height = 4, 
units = 'in', res=600)
  manhattan(res11, logp=T, ylim=c(0, ylim),suggestiveline=-log10(1e-5), col = c("blue4", "orange3"), cex=0.5, cex.axis = 1.0)
dev.off()
}
##########################################
