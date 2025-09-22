#!/bin/bash

SRA_ACCESSION_FILE=$1
OUT_FOLDER=$2

#tail -n +2 rna-seq-pipeline-3/metadata/SraRunTable_mouse_final.csv | cut -d',' -f1 > sra_accession_list.txt

echo >> $SRA_ACCESSION_FILE
while IFS= read -r acc; do prefetch $acc -O $OUT_FOLDER; fasterq-dump $OUT_FOLDER/$acc -O $OUT_FOLDER --split-files; pigz "$OUT_FOLDER/${acc}"*.fastq; done < $SRA_ACCESSION_FILE


