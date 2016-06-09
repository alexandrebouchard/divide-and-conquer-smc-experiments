#!/bin/bash

# old one: 2016-06-08-15-47-15-jj35xii2.exec
# new one: 2016-06-08-16-35-44-M032YcZt.exec

# Gather the data---only need to run once:
#wrun-collect -csv details.csv -where "folder_location = '/Users/bouchard/Documents/experiments/multilevelSMC2/results/all/2016-06-08-16-35-44-M032YcZt.exec'" -save
#cp results/latest/db.sqlite logZ.sqlite

Rscript logZ.r

