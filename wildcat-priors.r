# October 2020

reps=20000

sancvar=rexp(reps,0.1)+1
sf1=rbeta(reps,2,10)
sf2=rbeta(reps,2,10)

spop1=round(rlnorm(reps,meanlog=6.5,sdlog=0.5))
spop2=round(rlnorm(reps,meanlog=6.5,sdlog=0.5))
spop3=round(rlnorm(reps,meanlog=4.6,sdlog=0.5))
# impose minimum pop size for captive population (real data has 59 individuals)
for (i in 1:reps) {
    if(spop3[i] < 60) {
        spop3[i]=60 
        }
    }

shyb_time=round(rexp(reps,1/50))
scap_time=round(rgamma(reps,18*0.5,0.5))
smig1=rbeta(reps,5,20)
smig2=rgamma(reps,1,1)
smig2=smig2/spop3

priors=cbind(sancvar,sf1,sf2,spop1,spop2,spop3,shyb_time,scap_time,smig1,smig2)
write.table (priors,"priors.txt", col.names=F,row.names=F)
