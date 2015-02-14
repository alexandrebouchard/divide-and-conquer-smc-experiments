#!/bin/bash

# Gather the data---only need to run once:
# wrun-collect -simple executionInfo/end-time.txt -where "(plan = 'SMC-small' and git_commit_time = '2015-02-10 23:32:44' and model_use_uniform_variance = 'false') or (thin = '10' and stan_data_folder = 'data/NY-stan')" -save
# cp results/latest/db.sqlite timing.sqlite


Rscript create-timing-plots.r

# Quick and dirty summary for DC, STD
wrun-collect -simple executionInfo/end-time.txt -where "plan = 'SMC-small' and git_commit_time = '2015-02-10 23:32:44' and model_use_uniform_variance = 'false'" | wrun-search -pipe -select "sampling_method,dc_n_particles,count(folder_location),avg((cast(end_time as decimal) - cast(start_time as decimal))/1000),stdev((cast(end_time as decimal) - cast(start_time as decimal))/1000)" -where "end_time != '[empty]' group by sampling_method,dc_n_particles"

# Quick and dirty summary for STAN
wrun-collect -simple executionInfo/end-time.txt -where "thin = '10' and stan_data_folder = 'data/NY-stan'" | wrun-search -pipe -select "n_iteration,count(folder_location),avg((cast(end_time as decimal) - cast(start_time as decimal))/1000),stdev((cast(end_time as decimal) - cast(start_time as decimal))/1000)" -where "end_time != '[empty]' group by sampling_method,n_iteration"
