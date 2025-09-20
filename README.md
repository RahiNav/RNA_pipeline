# Downstream end-to-end RNA-seq analysis pipeline (expression quantification + differential expression)

## Software:
- Conda, Snakemake, R

## Description: 
- Runs end-to-end RNA-seq pipeline and produces quant.sf files from fastq files and runs DESeq2 pipeline on the quant files to produce analysis report which inlcude MA plots, PCA plot, heatmaps and KEGG and GO enrichment in form of HTML. It also produces a list of top 3 genes differentially expressed for each contrast (control vs condition 1.. and so on) based on the metadata provided.

## Pipeline Overview:
fastq > fastqc > multiqc > quant expression > DESeq2 > multiple plots (PCA, heatmap, MA) + GO/KEGG enrichment

## Results structure:
- /results
    - /fastqc 
    - /multiqc
    - /salmon
    - /ora
    - /deseq

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


### 4. Create environment.yaml file
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

- Metadata file: A excel file with metadata labelled as metadata.xlsx in metadata/ folder. Example of metadata file added here /metadata/samples_example.xlsx
- Raw files : Paired or single fastq files in raw_files/
- Reference files : gtf file and transcript file in ref_files/
- Intermediate file: Salmon index file in ref_files/
> [!Note]
> To generate Salmon index file please use the bash script from /generate_references

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
> If running on local system as oppose to cloud don't use higher cores. For e.g if your local system has 12 cores, specify 6 cores to avaoi overloading your system and crashing. However to use all available cores you can use --cores "all"

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



