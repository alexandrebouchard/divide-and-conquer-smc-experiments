#!/bin/bash

# Gather the data---only need to run once:
# wrun-collect -csv logZ.csv -where "(plan = 'SMC-small' or plan = 'large-SMC' or plan = 'more-SMC-replicates') and model_use_uniform_variance = 'false' and (git_commit_time = '2015-02-11 08:20:23' or git_commit_time = '2015-02-17 11:34:17')" -save
# cp results/latest/db.sqlite logZ.sqlite

Rscript logZ.r

echo "Summary of logZ results:"
cat logZ.sqlite | wrun-search -pipe -select "model_use_uniform_variance,sampling_method,dc_n_particles,factory_mcmc_n_mcmcsweeps,count(estimate),avg(estimate),stdev(estimate)" -where "input_data = 'data/preprocessedNYSData.csv' group by model_use_uniform_variance,sampling_method,dc_n_particles"



#cat logZ.sqlite | wrun-search -pipe -select "sampling_method,dc_n_particles,estimate" -delim "," > all-data.csv