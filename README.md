# Downstream end-to-end RNA-seq analysis pipeline (expression quantification + differential expression)
### Currently accepts only single end fastq files.

## Software:
- Conda, Snakemake, R

## Description: 
- This pipeline performs end-to-end RNA-seq analysis, starting from raw FASTQ files. It generates quant.sf files using Salmon and then runs a DESeq2 workflow on the quantifications to produce a comprehensive analysis report. The report, delivered in HTML format, includes MA plots, PCA plots, heatmaps, and KEGG/GO enrichment analyses. In addition, the pipeline extracts and reports the top three differentially expressed genes for each contrast (e.g., control vs. condition 1, condition 2, etc.). All steps (including DESeq2) is run in Snakemake. The user only needs to provide 1) complete metadata file e.g file in [samples.xlsx](/metadata/samples_example.xlsx), 2)required raw and reference files and 3) updated [config.yaml] file to reflect the names and path of the files. The results will be generated in /results folder (see organization below) and the DESeq2 analysis and KEGG and GO enrichement results are produced in a HTML report. Example report can be viewed [here](/results/deseq/deseq_analysis_example.html)

### Results structure:
- /results
    - /fastqc  
    - /multiqc 
    - /salmon
    - /ora
    - /deseq

## Pipeline Overview:
![Overview](/images/Overview.png)

## Steps:

### 1. Download miniforge
```
$curl -L https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-x86_64.sh -o Miniforge3-MacOSX-x86_64.sh
$bash Miniforge3-MacOSX-x86_64.sh
```

### 2. Clone repository

```
git clone <this-repo>
```

### 3. Set up a pyenv environment inside the folder
```
pyenv virtualenv <python version> <virtual envs name> 
pyenv local <virtual envs name>
```
> [!NOTE] 
> pyenv can be installed from [here](https://github.com/pyenv/pyenv/blob/master/README.md#installation)


### 4. Editing existing environment.yaml file (if needed).
```
vi environment.yaml 
```
> [!NOTE]
> Provided enviroment.yaml file already has all the packages needed for this pipeline to run. More packages can be added to the same enviromental.yaml file.

### 5. Activate base
```
conda activate base
```

### 6. Install mamba
```
conda install -n base -c conda-forge mamba
```

### 7. Create a new environment in mamba and install dependencies using enviroment.yaml file
```
mamba env create --name {enviroment_name} --file environment.yaml
```

### 8. Activate enviroment
```
conda activate {enviroment_name}  #snakemake-test-1
```
> [!NOTE]
> To view all existing environments in conda use $conda info --envs
 
### 9. Organize/Download/Create needed files

- Metadata file: A excel file with metadata labelled as metadata.xlsx in metadata/ folder. Example of metadata file added [here](/metadata/samples_example.xlsx)
- Raw files : Paired or single fastq files in raw_files/
- Reference files : gtf file and transcript file in ref_files/
- Intermediate file: Salmon index file in ref_files/
> [!Note]
> To generate Salmon index file please use the bash script from /generate_references

### 10. Update config file

```
vi config.yaml
```
> Update the necessary path for required paths and add sample names. 

### 10. Do a dry-run
```
snakemake -n
```   
> Correct any errors or open issues for any format errors

### 11. Run Snakemake 
```
snakemake --cores <no. of cores> #e.g. snakemake --cores 6
```
> [!Note]
> If running on local system as oppose to cloud don't use higher number cores. For e.g if your local system has 12 cores, specify 6 cores to avoid overloading your system and crashing. To use all available cores use --cores "all"

## Other helpful commands
### To create a dag of the snakemake workflow. 
```
snakemake --dag | dot -Tsvg > dag.svg
```
### To run only one rule in snakemake. 
```
snakemake --allowed-rules {rulename} 
#Also useful when you have changed the content of the any of the input files but want to avoid rerunning the rules.
```
### To retrigger 
```
snakemake --rerun-triggers mtime
#useful when you have updated metadata of the snakefile but want to avoid rerunning the rules
```
### Sources:
- https://hbctraining.github.io/Intro-to-rnaseq-fasrc-salmon-flipped/schedule/links-to-lessons.html
- https://snakemake.readthedocs.io/en/stable/tutorial/tutorial.html


