#!/bin/bash

# Gather the data---only need to run once:
# wrun-collect -csv logZ.csv -where "plan = 'SMC-small' or plan = 'large-SMC'" -save
# cp results/latest/db.sqlite logZ.db

Rscript create-logZ-boxPlot.r

echo "Summary of logZ results:"
cat logZ.db | wrun-search -pipe -select "model_use_uniform_variance,sampling_method,dc_n_particles,factory_mcmc_n_mcmcsweeps,count(estimate),avg(estimate),stdev(estimate)" -where "input_data = 'data/preprocessedNYSData.csv' group by model_use_uniform_variance,sampling_method,dc_n_particles"