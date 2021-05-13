# wildcat_abc

Simulate genetic data and run ABC using a demographic model for Scottish wildcats. For detailed description of modelling approach see [add citation]

## Overview 
### 1. Generate prior distribution
> Rscript script1_wildcat_priors.R

Samples from the prior distribution for each model parameter.
Specify the number of samples required using "reps", e.g. here reps=5.  
Resulting text file ("priors.txt") contains 10 columns and "reps" number of rows (one column per model parameter, each row containing the parameter values for a single simulation)


### 2. Run simulations with SLiM and generate summary statistics in R
> bash script2_run_simulation.sh

This script loops through simulations, each iteration reading one row of priors.txt.    
Values from priors.txt are passed to SLiM as constants. SLiM output is converted to a 012 matrix using vcftools.   
Summary statistics are computed from the 012 matrix in R.  
The "START" and "END" variables control the rows of priors.txt passed to SLiM, e.g. here the first 5 rows of priors.txt are used  

* To run this script the following packages must be installed:
	+ slim (https://messerlab.org/slim/)
	+ vcftools (https://vcftools.github.io/man_latest.html)
	+ littler (https://cran.r-project.org/web/packages/littler/index.html)
	+ adegenet (https://cran.r-project.org/web/packages/adegenet/index.html)
	+ hierfstat (https://cran.r-project.org/web/packages/hierfstat/index.html)

* The following files must be in the working directory:
	+ wildcat_simulation.txt
	+ wildcat_summary_stats.R


### 3. ABC
> Explore ABC results (interactively) using script3_abc.R

Code available to:  
	Remove aborted simulations and transform priors (population sizes transformed to log(pop size))  
	Project summary statistics (using fp_proj.R)  
	Perform goodness-of-fit test  
	Perform ABC   

* To run this script the following package must be installed:
	+ abc (https://cran.r-project.org/web/packages/abc/index.html)

* The following files must be in the working directory:
	+ fp_proj.R
	+ target_data.txt
  
  
### 4. Additional scripts
Also provided is code used to remove poorly performing summary statistics, this can be found in dropping_stats.R
