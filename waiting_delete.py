#!/usr/bin/python
# this function is for generate gene expression matrix 
# 2 parameters or 3 parameters
# 1st parameter, input folder, which contains cell level statistic
# 2nd parameter, folder, output filename
# 3rd parameter, read counts methods, default choise is featurecounts

import os
import sys
from os import listdir
from os.path import isfile, join

# arguments
arguments = sys.argv
input_folder = arguments[1]
output_filename = arguments[2]
# method choice, default is featurecounts
if(len(arguments) == 4):
    method_case = arguments[3]
else:
    method_case = None


def main():
    # default setting is featurecounts
    if method_case is None:
        featurecounts_expression_matrix()
    # other setting
    else:
       pass 

def featurecounts_expression_matrix():
    suffix=".featurecounts"
    onlyfiles = [f for f in listdir(input_folder) if isfile(join(input_folder, f)) if f.endswith(suffix)]
    for f in onlyfiles:
        cell_level_file = join(input_folder, f)
        print(cell_level_file)

if __name__ == '__main__':
    main()
