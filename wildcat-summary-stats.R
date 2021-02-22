# October 2020

library(hierfstat)
library(adegenet)

args = commandArgs(trailingOnly=TRUE)

m1 = read.table(args[1])
m1 = m1[,-1]


if (dim(m1)[1] < 95) {
	
	# Remove aborted simulations
	ssrep=rep(NA,22)

} else {
	
	# Remove monomorphic sites
	m1 <- m1[ , apply(m1, 2, var) != 0]

	# Clustering
	n=dim(m1)[1]
	m1.scale = scale(m1)
	
	d1 = dist(m1.scale) #Euclidean distance between pairs of individuals 
	ha1 = hclust(d1,method="complete")
	hcalc = function(x){
	v1 = as.numeric(table(x))
	v1/sum(v1)
	}
	nefcalc = function(x){1/sum(hcalc(x)^2)}
	gp1 = cutree(ha1,k=1:n)
	nefa1 = apply(gp1,2,nefcalc)
	stata1 = c(1:n)/nefa1
	ss2 = log(mean(stata1))
	
	# PCA
	xx = prcomp(m1, scale=T)
	
	ss3 = as.numeric(quantile(xx$x[,1],seq(0,1,length=9)))
	ss3 = (rev(ss3) - ss3)[1:4]

	ss4 = as.numeric(quantile(xx$x[,2],seq(0,1,length=9)))
	ss4 = (rev(ss4) - ss4)[1:4]
	
	# Genetic distance
	# Make genind
	loci=m1
	population<-c(rep("pop1",4), rep("pop2",45), rep("pop3",46))
	mydata1<-df2genind(loci, ploidy=2, pop=population, sep="")
	# Chord distance
	dis<-as.numeric(genet.dist(mydata1))
	ss5<-dis[1]
	ss6<-dis[2]
	ss7<-dis[3]

	
	# Linkage
	snpfilter=function(x,maf){af=apply(x,2,sum)/(2*dim(x)[1])
	wt=!(af <= maf | 1-af <= maf)
	x[,wt]}

	r2filter=function(x){geno.sd = apply(x,2,sd)
	wt = geno.sd > 0
	x[,wt]}
  
	m.filt = r2filter(m1)
	r1 = cor(m.filt)
	r2 = as.numeric(r1[upper.tri(r1)]^2)
	r2.mean = mean(r2)
	nest1 = 1/(3*r2.mean - 1/dim(m.filt)[1])
	ss8 = nest1
	ss9 = sd(r2)
	
	ssrep = c(ss2,ss3,ss4,ss5,ss6,ss7,ss8,ss9)
	if(length(ssrep) != 14)ssrep = rep(NA,14)
		
}

print(ssrep)

write.table(t(as.matrix(ssrep)), paste("summary_stats_",args[2],".txt",sep=""), sep="\t",col.names=F,row.names=F, append=T)