rule run_ccs_dc:
    input:
        bam = "bam_files/{seeds}_{hap}_{sample}_{chr_nm}.bam"
    output:
        ccsbam = "ccs_dc_bam/{seeds}_{hap}_{sample}_{chr_nm}.bam"
    resources:
        mem_mb=100000
    shell:
        "ccs {input.bam} {output.ccsbam} -j 5"


rule actc:
    input:
        ori_subs="bam_files/{seeds}_{hap}_{sample}_{chr_nm}.bam"
        ccs_subs="ccs_dc_bam/{seeds}_{hap}_{sample}_{chr_nm}.bam"
    output:
        touch("actc/{seeds}_{hap}_{sample}_{chr_nm}.subreads_to_ccs_actc.bam")
    threads:
        workflow.cores
    shell: """
        actc -j {threads}  \
        {input.orisubs} \
        {input.ccs_subs} \
        {output}
    """

rule deepconsensus:
    input:
        actc_subs="actc/{seeds}_{hap}_{sample}_{chr_nm}.subreads_to_ccs_actc.bam",
        ccs_subs="ccs_dc_bam/{seeds}_{hap}_{sample}_{chr_nm}.bam"
    output:
        "ccs_dc_bam/{seeds}_{hap}_{sample}_{chr_nm}.fastq.gz"
    envmodules:
        "deepconsensus/0.3.1"
    shell: """
        deepconsensus run \
        --subreads_to_ccs={input.actc_subs}  \
        --ccs_bam={input.ccs_subs} \
        --checkpoint=model/checkpoint \
        --output={output}
    """

rule merge_fq:
    input:
        expand("ccs_dc_bam/{seeds}_{hap}_{sample}_{chr_nm}.fastq",chunknumber=CHUNK_NMB, prefix=FILE_PREFIX)
    output:
        "ccs_dc_bam/{seeds}_{hap}_{sample}_{chr_nm}.merged_ccs.fastq"
    shell: """
        cat {input} > output
    """

rule compress_fq:
    input:
        "ccs_dc_bam/{seeds}_{hap}_{sample}_{chr_nm}.merged_ccs.fastq"
    output:
        "fastq_files/{seeds}_{hap}_{sample}_{chr_nm}.fastq.gz"
    shell: """
        gzip -c {input} > {output}
    """