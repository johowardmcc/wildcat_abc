# Set number of simulations
# E.g. to simulate from first 5 rows of priors.txt
START=1
END=5

for (( sim=$START; sim<=$END; sim++ ))
do

	echo SIMULATION  $sim

	# Set parameter values
	
	sed -n $sim"p" priors.txt > temp 

	ancvar=$(awk '{print $1}' temp)
	f1=$(awk '{print $2}' temp)
	f2=$(awk '{print $3}' temp)
	pop1=$(awk '{print $4}' temp)
	pop2=$(awk '{print $5}' temp)
	pop3=$(awk '{print $6}' temp)
	
	hyb_time=$(awk '{print $7}' temp)
	# Prior for hyb_time (T1) and cap_time (T2) are generations before present
	# Convert to number of generations after simulation start for SLiM (forward simulator)
	hyb_time=$(r -e "cat(as.integer(500-$hyb_time),sep='\n')")
	echo Hyb_time is $hyb_time
	cap_time=$(awk '{print $8}' temp)
	cap_time=$(r -e "cat(as.integer(500-$cap_time),sep='\n')")
	echo Cap_time is $cap_time
	
	mig1=$(awk '{print $9}' temp)
	mig2=$(awk '{print $10}' temp)

	rm temp

	# Run SLiM

	./slim -d Ancvar=$ancvar -d F1=$f1 -d F2=$f2 -d Pop1=$pop1 -d Pop2=$pop2 -d Pop3=$pop3 -d Hyb_time=$hyb_time -d Cap_time=$cap_time -d Mig1=$mig1 -d Mig2=$mig2 wildcat_simulation.txt > wildcatsim_out$sim.txt

	# Format output and convert to 012 matrix
	
	sed -i '/##/,$!d' wildcatsim_out$sim.txt
	mv wildcatsim_out$sim.txt wildcatsim_out$sim.vcf
	vcftools --vcf wildcatsim_out$sim.vcf --min-alleles 2 --max-alleles 2 --012 --out wildcatsim_out$sim
	
	# Generate summary statistics in R
	
	Rscript wildcat_summary_stats.R wildcatsim_out$sim.012
	rm wildcatsim_out$sim.vcf
	rm wildcatsim_out$sim.012*
	
	
done

echo End time is `date`
