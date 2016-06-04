#!/bin/bash

echo "method,ESS,time_sec,ess_per_sec,ess_per_min"


### GIBBS

wrun-collect -csv logDensity-csv/logDensity.csv -select "folder_location" -where "plan = 'GIBBS-new' and init_gibbs_with_std_smc	= 'false' and main_random = '1' and git_commit_time = '2015-02-12 23:50:23'"   | wrun-search -pipe -select "log_density" -where "cast(mcmc_iter as decimal) > 100" > gibbs-3m-logl-samples.csv

ESS=`java -cp ~/w/multilevelSMC/build/install/multilevelSMC/lib/\*  multilevel.mcmc.ESSMain -samples gibbs-3m-logl-samples.csv | sed 's/log.density.//'`

# Source: analyses/posteriors/create-densities.r
TIME_SEC=21600

ESS_PER_SEC=`echo "$ESS / $TIME_SEC" | bc -l`
ESS_PER_MIN=`echo "$ESS_PER_SEC * 60" | bc -l`

echo "GIBBS-3m,$ESS,$TIME_SEC,$ESS_PER_SEC,$ESS_PER_MIN"


### STAN

awk '{print $2}' /Users/bouchard/Documents/experiments/multilevelSMC2/results/all/2015-02-13-10-25-19-YEsnneZV.exec/logDensity/codaContents > temp
echo log_density | cat - temp > stan-200k-logl-samples.csv
rm temp

ESS=`java -cp ~/w/multilevelSMC/build/install/multilevelSMC/lib/\*  multilevel.mcmc.ESSMain -samples stan-200k-logl-samples.csv | sed 's/log.density.//'`

# Source: analyses/posteriors/create-densities.r
TIME_SEC=708189

ESS_PER_SEC=`echo "$ESS / $TIME_SEC" | bc -l`
ESS_PER_MIN=`echo "$ESS_PER_SEC * 60" | bc -l`

echo "STAN-200k,$ESS,$TIME_SEC,$ESS_PER_SEC,$ESS_PER_MIN"


### ESS for SMC methods (DC and STD)

for i in DC STD
do 
  RUN_LOC=`wrun-search -select folder_location,dc_n_particles -where "model_use_uniform_variance = 'false' and plan = 'SMC-small' and main_random = '1' and git_commit_time = '2015-02-11 08:20:23' and sampling_method = '$i' and dc_n_particles = '10000'" | tail -n 1 | awk '{print $1}'`
  ESS=`tail -n 1 $RUN_LOC/ess.csv | sed 's/.*NY,//' | sed 's/,.*//'`
  
  TIME_SEC=`wrun-collect -simple executionInfo/end-time.txt -where "plan = 'SMC-small' and git_commit_time = '2015-02-10 23:32:44' and model_use_uniform_variance = 'false' and main_random = '1' and sampling_method = '$i' and dc_n_particles = '10000'" | wrun-search -pipe -select "(cast(end_time as decimal) - cast(start_time as decimal))/1000" -where "end_time != '[empty]'" | tail -n 1`
  
  ESS_PER_SEC=`echo "$ESS / $TIME_SEC" | bc -l`
  ESS_PER_MIN=`echo "$ESS_PER_SEC * 60" | bc -l`
  
  echo "${i}-10k,$ESS,$TIME_SEC,$ESS_PER_SEC,$ESS_PER_MIN"
done
