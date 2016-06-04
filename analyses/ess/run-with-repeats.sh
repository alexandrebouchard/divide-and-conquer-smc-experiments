#!/bin/bash

# Similar to run.sh, except that we pick smaller runs that have repetitions for GIBBS and stan, to get std

N_REP=10

echo "method,replicate,ESS,time_sec,ess_per_sec,ess_per_min" #TODO: change this


### STAN

for REPLICATE in `seq 1 $N_REP`
do

  # only need to run once:
  #cd ~/experiments/multilevelSMC2/
  #java -cp ~/w/multilevelSMC/build/install/multilevelSMC/lib/\*  multilevel.stan.AnalyzeStanOuput -inputData data/preprocessedNYSData.csv -stanOutput data/stan-samples/outputs/output-20000-iters-${REPLICATE}.csv
  #cd -

  # find exec where the stan output was processed
  PROCESSED_STAN_EXEC=`wrun-search -select folder_location -where "stan_output = 'data/stan-samples/outputs/output-20000-iters-${REPLICATE}.csv'" | tail -n 1`

  awk '{print $2}' ${PROCESSED_STAN_EXEC}/logDensity/codaContents > temp
  echo log_density | cat - temp > temp2.csv
  rm temp

  ESS=`java -cp ~/w/multilevelSMC/build/install/multilevelSMC/lib/\*  multilevel.mcmc.ESSMain -samples temp2.csv | sed 's/log.density.//'`
  rm temp2.csv

  # Source: analyses/posteriors/create-densities.r
  TIME_SEC=708189

  ESS_PER_SEC=`echo "$ESS / $TIME_SEC" | bc -l`
  ESS_PER_MIN=`echo "$ESS_PER_SEC * 60" | bc -l`

  echo "STAN-20k,$REPLICATE,$ESS,$TIME_SEC,$ESS_PER_SEC,$ESS_PER_MIN"
  
done


### GIBBS


for REPLICATE in `seq 1 $N_REP`
do
  wrun-collect -csv logDensity-csv/logDensity.csv -select "folder_location" -where "plan = 'GIBBS-new' and init_gibbs_with_std_smc	= 'false' and main_random = '$REPLICATE' and git_commit_time = '2015-02-12 23:50:23'"   | wrun-search -pipe -select "log_density" -where "cast(mcmc_iter as decimal) > 100" > temp.csv

  ESS=`java -cp ~/w/multilevelSMC/build/install/multilevelSMC/lib/\*  multilevel.mcmc.ESSMain -samples temp.csv | sed 's/log.density.//'`
  rm temp.csv

  # Source: analyses/posteriors/create-densities.r
  TIME_SEC=21600

  ESS_PER_SEC=`echo "$ESS / $TIME_SEC" | bc -l`
  ESS_PER_MIN=`echo "$ESS_PER_SEC * 60" | bc -l`

  echo "GIBBS-3m,$REPLICATE,$ESS,$TIME_SEC,$ESS_PER_SEC,$ESS_PER_MIN"
done


### ESS for SMC methods (DC and STD)

for method in DC STD
do 
  for REPLICATE in `seq 1 $N_REP`
  do
    RUN_LOC=`wrun-search -select folder_location,dc_n_particles -where "model_use_uniform_variance = 'false' and plan = 'SMC-small' and main_random = '$REPLICATE' and git_commit_time = '2015-02-11 08:20:23' and sampling_method = '$method' and dc_n_particles = '10000'" | tail -n 1 | awk '{print $1}'`
    ESS=`tail -n 1 $RUN_LOC/ess.csv | sed 's/.*NY,//' | sed 's/,.*//'`
  
    TIME_SEC=`wrun-collect -simple executionInfo/end-time.txt -where "plan = 'SMC-small' and git_commit_time = '2015-02-10 23:32:44' and model_use_uniform_variance = 'false' and main_random = '$REPLICATE' and sampling_method = '$method' and dc_n_particles = '10000'" | wrun-search -pipe -select "(cast(end_time as decimal) - cast(start_time as decimal))/1000" -where "end_time != '[empty]'" | tail -n 1`
  
    ESS_PER_SEC=`echo "$ESS / $TIME_SEC" | bc -l`
    ESS_PER_MIN=`echo "$ESS_PER_SEC * 60" | bc -l`
  
    echo "${method}-10k,$REPLICATE,$ESS,$TIME_SEC,$ESS_PER_SEC,$ESS_PER_MIN"
  done
done
