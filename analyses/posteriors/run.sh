#!/bin/bash

# Rerunnning this not needed: old version did not create the sample.csv file
# for i in `wrun-collect -simple executionInfo/end-time.txt -where "stan_data_folder = 'data/NY-stan' and (n_iteration = '200' or n_iteration = '2000')"  | wrun-search -pipe -select "folder_location"`
# do
#   java -cp ~/w/multilevelSMC/build/install/multilevelSMC/lib/\*  multilevel.stan.AnalyzeStanOuput -stanOutput $i/output.csv -inputData data/preprocessedNYSData.csv 
#   cp results/latest/samples.csv $i/
# done

# Gather the data---only need to run once:
# wrun-collect -csv samples.csv -select "coalesce(sampling_method,'STAN') as sampling_method,coalesce(dc_n_particles,n_iteration,'200000') as n_iterations,folder_location" -where "(plan = 'GIBBS-new' and init_gibbs_with_std_smc	= 'false' and git_commit_time = '2015-02-12 23:50:23') or (model_use_uniform_variance = 'false' and plan = 'SMC-small' and main_random = '1' and git_commit_time = '2015-02-11 08:20:23') or (stan_data_folder = 'data/NY-stan' and seed = '1') or folder_location = '/Users/bouchard/Documents/experiments/multilevelSMC2/results/all/2015-02-13-10-25-19-YEsnneZV.exec' order by sampling_method,n_iterations" -save
# cp results/latest/db.sqlite samples.sqlite

# Gather some deeper data too
# wrun-collect -csv samples.csv -select "sampling_method, dc_n_particles as n_iterations,folder_location" -where "dc_level_cut_off_for_output = '3'" -save
# cp results/latest/db.sqlite deeper-samples.sqlite


Rscript create-densities.r
