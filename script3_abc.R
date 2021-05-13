library(abc)

sstable<-read.table("sstable.txt")
priors<-read.table("priors.txt")
target<-read.table("target_data.txt",header=T)

# Remove NAs and transform priors
ref.table<-cbind(priors,sstable)
na.list=apply(is.na(ref.table),1,any)
ref.table<-ref.table[!na.list,]

t.priors<-ref.table[,1:3]
colnames(t.priors)<-c("ancvar","F1","F2")
t.priors$log.pop1<-log(ref.table[,4])
t.priors$log.pop2<-log(ref.table[,5])
t.priors$log.pop3<-log(ref.table[,6])
t.priors$hyb_time<-ref.table[,7]
t.priors$cap_time<-ref.table[,8]
t.priors$mig1<-ref.table[,9]
t.priors$mig2<-ref.table[,10]

priors<-t.priors
sstable<-ref.table[,11:24]

# Projection
source("fp_proj.R")

proj.mat<-get_fp_proj(tolx=0.2,sstable=sstable,params=priors,target=target)
proj.sstable<-make_fp_proj(proj.mat,sstable)
proj.target<-make_fp_proj(proj.mat,target)

# GOF
res.gfit<-gfit(proj.target,proj.sstable,statistic=mean,nb.replicate=100)
plot(res.gfit, main="Histogram under H0")
summary(res.gfit)

# ABC
res<-abc(proj.target,priors,proj.sstable,tol=0.01,method="neuralnet")
plot(res,priors)
