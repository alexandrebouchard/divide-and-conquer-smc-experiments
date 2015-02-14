#!/bin/bash

# Gather the data---only need to run once:
# wrun-collect -simple executionInfo/end-time.txt -where "(plan = 'SMC-small' and git_commit_time = '2015-02-10 23:32:44' and model_use_uniform_variance = 'false') or (thin = '10' and stan_data_folder = 'data/NY-stan')" -save
# cp results/latest/db.sqlite timing.sqlite


Rscript create-timing-plots.r

# Quick and dirty summary for DC, STD
wrun-collect -simple executionInfo/end-time.txt -where "plan = 'SMC-small' and git_commit_time = '2015-02-10 23:32:44' and model_use_uniform_variance = 'false'" | wrun-search -pipe -select "sampling_method,dc_n_particles,count(folder_location),avg((cast(end_time as decimal) - cast(start_time as decimal))/1000),stdev((cast(end_time as decimal) - cast(start_time as decimal))/1000)" -where "end_time != '[empty]' group by sampling_method,dc_n_particles"

# Quick and dirty summary for STAN
wrun-collect -simple executionInfo/end-time.txt -where "thin = '10' and stan_data_folder = 'data/NY-stan'" | wrun-search -pipe -select "n_iteration,count(folder_location),avg((cast(end_time as decimal) - cast(start_time as decimal))/1000),stdev((cast(end_time as decimal) - cast(start_time as decimal))/1000)" -where "end_time != '[empty]' group by sampling_method,n_iteration"



# 
# ################################################################################
# 

# 
# 
# # Gather the five types of run
# wrun-collect -csv samples.csv -select "folder_location" -where "model_use_uniform_variance = 'false' and (plan = 'GIBBS-new' or plan = 'SMC-small' or stan_data_folder = 'data/NY-stan') and (seed = '1' or main_random = '1')" -save
# 
# 
# ### query to get the STD and DC jobs:
# wrun-search -select "sampling_method,dc_n_particles,folder_location" -where "model_use_uniform_variance = 'false' and plan = 'SMC-small' and main_random = '1' and git_commit_time = '2015-02-11 08:20:23'"
# 
# ### query to get the STAN jobs:
# wrun-search -select "n_iteration,folder_location" -where "stan_data_folder = 'data/NY-stan' and seed = '1'"
# 
# 
# wrun-search -select "coalesce(sampling_method,'STAN') as sampling_method,coalesce(dc_n_particles,n_iteration) as iterations,folder_location" -where "(model_use_uniform_variance = 'false' and plan = 'SMC-small' and main_random = '1' and git_commit_time = '2015-02-11 08:20:23') or (stan_data_folder = 'data/NY-stan' and seed = '1') order by sampling_method,iterations"
# 
# 
# 
# ### query to get the GIBBS jobs:   ##NB: will need to subsample manually
# wrun-search -select "git_commit_time,folder_location"  -where "model_use_uniform_variance = 'false' and plan = 'GIBBS-new'" PROBLEM : NOT CONTROLLING FOR SMC INIT??
# 
# 
# 
#   might be when you initialize??
# 
# ## query to get the stan jobs
# 
# 
# 
# wrun-search -selectAll -where "(plan = 'GIBBS-new' or plan = 'SMC-small' or plan='large-SMC' or stan_data_folder = 'data/NY-stan') and (seed = '1' or main_random = '1')"
# 
# wrun-collect -csv samples.csv  -where "stan_data_folder = 'data/NY-stan' and (seed = '1' or main_random = '1')" | wrun-search -pipe -selectAll
# 
# echo "Timing in minutes for DC, STD, and GIBBS:"
# wrun-collect -simple executionInfo/end-time.txt -where "(plan = 'GIBBS-new' or plan = 'SMC-small' or plan='large-SMC') and input_data = 'data/preprocessedNYSData.csv'" | wrun-search -pipe -select "model_use_uniform_variance,sampling_method,dc_n_particles,factory_mcmc_n_mcmcsweeps,git_commit_time,count(folder_location),avg((cast(end_time as decimal) - cast(start_time as decimal))/1000),stdev((cast(end_time as decimal) - cast(start_time as decimal))/1000)" -where "end_time != '[empty]' group by model_use_uniform_variance,sampling_method,dc_n_particles,factory_mcmc_n_mcmcsweeps,git_commit_time"
# 
# echo "One result folder for each batch for DC, STD, and GIBBS"
# wrun-collect -simple executionInfo/end-time.txt -where "(plan = 'GIBBS-new' or plan = 'SMC-small' or plan='large-SMC') and input_data = 'data/preprocessedNYSData.csv' and main_random = '1'" | wrun-search -pipe -select "model_use_uniform_variance,sampling_method,dc_n_particles,factory_mcmc_n_mcmcsweeps,git_commit_time,folder_location" -where "end_time != '[empty]' order by model_use_uniform_variance,sampling_method,dc_n_particles,factory_mcmc_n_mcmcsweeps,git_commit_time"
# 
# echo "Folder locations for stan"
# wrun-search -where "stan_data_folder = 'data/NY-stan' and (n_iteration = '200' or n_iteration = '2000')"  -select "n_iteration,seed,thin,burn_in_fraction,folder_location"
# 
# 
# 
# wrun-collect -csv logDensity-summary.csv | wrun-search -pipe -select "model_use_uniform_variance,ess_threshold,sampling_method,dc_n_particles,count(mean),avg(mean),stdev(mean)" -where "input_data = 'data/preprocessedNYSData.csv' group by model_use_uniform_variance,ess_threshold,sampling_method,dc_n_particles"
# 
# 
# wrun-collect -csv samples.csv -where "folder_location = '/Users/bouchard/Documents/experiments/multilevelSMC2/results/all/2015-02-11-13-59-39-yIHaGBlr.exec'" -save
# 
# wrun-search -selectAll  -where "folder_location = '/Users/bouchard/Documents/experiments/multilevelSMC2/results/all/2015-02-11-13-59-39-yIHaGBlr.exec'"
# 
#  | wrun-search -pipe -select "node,variable,count(value)" -where "variable = 'meanSample' and node = 'NY-Kings' group by 'sampling_method'"
# 
# wrun-search -selectAll -where "(plan = 'GIBBS-new' or plan = 'SMC-small' or plan='large-SMC' or stan_data_folder = 'data/NY-stan') and (seed = '1' or main_random = '1') and dc_n_particles = '100'" 
# 
# 
# 
# # 
# # wrun-collect -csv logDensity-summary.csv | wrun-search -pipe -select "model_use_uniform_variance,sampling_method,dc_n_particles,factory_mcmc_n_mcmcsweeps,folder_location" -where "(plan = 'GIBBS-new' or plan = 'SMC-small') and input_data = 'data/preprocessedNYSData.csv' and main_random = '1'"
# # 
# # 
# # 
# # wrun-collect -csv logZ.csv -where "plan = 'SMC-small' or plan = 'large-SMC'" | wrun-search -pipe -select "model_use_uniform_variance,sampling_method,dc_n_particles,factory_mcmc_n_mcmcsweeps,count(estimate),avg(estimate),stdev(estimate)" -where "input_data = 'data/preprocessedNYSData.csv' group by model_use_uniform_variance,sampling_method,dc_n_particles"
# 
#  
