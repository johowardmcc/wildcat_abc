library(distances)

ssall<-rbind(target,sstable)
x=dim(ssall)
dvec1  = numeric(x) # make a vector of length equal to number of simulated points plus target
                    # target is the first observation
res1 = matrix(nrow=22,ncol=3) # result matrix, one row per summ stat

for(k in 1:22){ # test the effect of dropping stats 1 to 22

	# to skip rows already dropped add them here
	# e.g. to skip k==1 and k==2
	if(k==1 || k==2){
		res1[k,] = NA # NA for rows we've already dropped
		next
	}

	q1.pca = prcomp(ssall[,-c(k, 1, 2)],scale=T) # these are the currently dropped columns, including the kth row we are currently testing

	mh1 = distances(q1.pca$x) # calculates a *compact* distance matrix between all rows of ssall

	nnd1 = nearest_neighbor_search(mh1,2) # searches for the nearest neigbour
	for(j in 1:x)dvec1[j] = mh1[j,nnd1[2,j]] # nearest neighbour distance for each point.
	res1[k,1] = dvec1[1] # nearest neighbour distance for target
	res1[k,2] = median(dvec1) # median nearest neighbour distance for simulated points
	res1[k,3] = sum(dvec1 > dvec1[1]) # number of points with nearest neighbour further than the nearest neighbour of target. 
	print(k)
}