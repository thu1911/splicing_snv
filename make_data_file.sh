#!/bin/bash
#######################################

cat E-MTAB-2600.sdrf.txt | awk '/^2i_([1-9]\t|10\t)/ ' >> experiment_data.txt
cat E-MTAB-2600.sdrf.txt | awk '/^2i_[3-5]_([1-9]\t|10\t)/ ' >> experiment_data.txt

