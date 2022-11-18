#TO plot PCs of 1KGP and subjects

data=read.table("subjects_merged_1kgp.pca.evec",h=F,skip=1,sep="")

dataset=which(data$V12=="Control")
AFR=which(data$V12=="3")
AMR=which(data$V12=="4")
EAS=which(data$V12=="5")
CEU=which(data$V12=="6")
SAS=which(data$V12=="7")

plot(0,0,pch="",xlim=c(-0.05,0.05),ylim=c(-0.05,0.05),xlab="Principal component 1", ylab="Principal component 2")
points(data$V2[EAS],data$V3[EAS],pch=20,col="PURPLE")
points(data$V2[CEU],data$V3[CEU],pch=20,col="GREEN")
points(data$V2[AFR],data$V3[AFR],pch=20,col="RED")
points(data$V2[SAS],data$V3[SAS],pch=20,col="BROWN")
par(cex=1)
points(data$V2[child],data$V3[dataset],pch=20,col="BLACK")
abline(h=0.004,v=0.004,col="gray32",lty=2)
#legend("topright", c("African", "Cseentral European", "East Asian", "South Asian"), fill=c("RED", "GREEN", "PURPLE", "BROWN"))
legend("topright", c("African", "Central European", "East Asian", "South Asian", "CHILD"), fill=c("RED", "GREEN", "PURPLE", "BROWN", "BLACK"))
