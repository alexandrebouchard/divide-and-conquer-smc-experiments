This repository contains the command line options used to create the results of Section 5.2 of our [arXiv preprint.](http://arxiv.org/abs/1406.4993). The code itself is available in this [other repository](http://github.com/alexandrebouchard/divide-and-conquer-smc). 

The paper explaining this method is under review. Please contact us if you would like to use the software.

Organization (note, these files were created using [westrun](https://github.com/alexandrebouchard/westrun):

- ``plans`` contains template files used to start experiments. For example, values such as ``@@{1--10}`` and ``@@{10^[1 -- 5]}`` generate a cross product of experiments with values (1, 10), (2,100), .., (10, 10000) substituted.
- ``analyses`` contains the scripts used for summarizing the results into plots. In each subdirectory:
    - ``run.sh`` aggregates csv files (you can find there git commits in particular)
    - ``*.sqlite``: the actual data
    - ``*.r``: plotting script