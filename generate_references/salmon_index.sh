#!/bin/bash

transcript_file=$1 #transcripts .fa file
salmon_index_parameter=$2 #index prefix name

salmon index -t $transcript_file -i $salmon_index_parameter