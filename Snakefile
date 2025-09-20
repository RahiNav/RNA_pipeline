configfile: "config.yaml"

rule all:
    input:
        quantFile = expand("results/salmon/{sample}/quant.sf", sample=config["SAMPLES"]),
        htmlReport = config['HTMLREPORT']

rule fastqc:
    input:
        fa = lambda wildcards: f"{config['RAW_FILE_FOLDER']}/{wildcards.sample}.fastq.gz"
    output:
        html1 = "results/fastqc/{sample}/{sample}_fastqc.html"
    params:
        fastqc_dir = "results/fastqc/{sample}/"    
    shell:
        "fastqc -o {params.fastqc_dir} {input.fa}"

rule runMultiqc:
    input:
        html1 = expand("results/fastqc/{sample}/{sample}_fastqc.html", sample = config["SAMPLES"])
    output:
        multiqc_report = "results/multiqc/multiqc_report.html",
    params:
        fastqc_dir = "results/fastqc/",
        multiqc_dir = "results/multiqc/"
    shell:
        "multiqc {params.fastqc_dir} -o {params.multiqc_dir}"                     

rule salmon_quant:
    input:
        multiqc_report = "results/multiqc/multiqc_report.html",
        fa = lambda wildcards: f"{config['RAW_FILE_FOLDER']}/{wildcards.sample}.fastq.gz",
        salmon_index = config["SALMON_INDEX_FOLDER"]
    output:
        quantFile = "results/salmon/{sample}/quant.sf"
    params:
        quant_folder = "results/salmon/{sample}/"    
    shell:
        "salmon quant -i {input.salmon_index} -l A \
         -r {input.fa} \
         --validateMappings -o {params.quant_folder}"

rule deseq:
    input:
        quantFiles = expand("results/salmon/{sample}/quant.sf", sample=config["SAMPLES"]),
        rmarkdown = config["RMARKDOWN"],
        metadataFile = config["METADATAFILE"]
    output:
        htmlReport = config["HTMLREPORT"]
    shell:
        """
        Rscript -e "rmarkdown::render(
            '{input.rmarkdown}', 
            params = list(input_file='{input.metadataFile}'),
            output_file=basename('{output.htmlReport}'),
            output_dir=dirname('{output.htmlReport}')
        )"
        """