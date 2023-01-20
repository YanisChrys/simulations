# perform simulations for contaminant dna

def cont1_looper(cat=""):
    for i in chromnum_cont1_list:
        if cat == "maf":
            yield "/share/pool/simulations_collomics/cont1/cont1_{}.maf".format(i)
        elif cat == "ref":
            yield "/share/pool/simulations_collomics/cont1/cont1_{}.ref".format(i)
        elif cat == "sam":
            yield "/share/pool/simulations_collomics/cont1/cont1_{}.sam".format(i)

def cont2_looper(cat=""):
    for i in chromnum_cont2_list:
        if cat == "maf":
            yield "/share/pool/simulations_collomics/cont2/cont2_{}.maf".format(i)
        elif cat == "ref":
            yield "/share/pool/simulations_collomics/cont2/cont2_{}.ref".format(i)
        elif cat == "sam":
            yield "/share/pool/simulations_collomics/cont2/cont2_{}.sam".format(i)


rule run_sim_cont1:
    input: 
        genome = contaminant_1
    output:
        bam = temp(cont1_looper(cat="sam")),
        ref = temp(cont1_looper(cat="ref")),
        maf = temp(cont1_looper(cat="maf"))
    params:
        prefix_sim = "/share/pool/simulations_collomics/cont1/cont1",
        depth=cont1depth,
        lngth = config["read_length"]
#    envmodules:
#        "pbsim3/3.0.0"
    resources:
        mem_mb=100000
    shell: """
        module load pbsim3/3.0.0
        pbsim --prefix {params.prefix_sim} --strategy wgs --genome {input.genome} \
        --depth {params.depth} --method errhmm --errhmm /share/scientific_src/pbsim3/3.0.0/data/ERRHMM-SEQUEL.model \
        --length-mean {params.lngth} --pass-num 10
    """

rule run_sim_cont2:
    input: 
        genome = contaminant_2
    output:
        bam = temp(cont2_looper(cat="sam")),
        ref = temp(cont2_looper(cat="ref")),
        maf = temp(cont2_looper(cat="maf"))
    params:
        prefix_sim = "/share/pool/simulations_collomics/cont2/cont2",
        depth=cont2depth,
        lngth = config["read_length"]
#    envmodules:
#        "pbsim3/3.0.0"
    resources:
        mem_mb=100000
    shell: """
        module load pbsim3/3.0.0
        pbsim --prefix {params.prefix_sim} --strategy wgs --genome {input.genome} \
        --depth {params.depth} --method errhmm --errhmm /share/scientific_src/pbsim3/3.0.0/data/ERRHMM-SEQUEL.model \
        --length-mean {params.lngth} --pass-num 10
    """


rule make_bam_conta1:
    input:
        sam1 = "/share/pool/simulations_collomics/cont1/cont1_{chrn1}.sam"
    output:
        bam1 = "bam_files/cont1_{chrn1}.bam"
    shell: """
        samtools view -b {input.sam1} -o {output.bam1} --threads 30 
    """

rule make_bam_conta2:
    input:
        sam2 = "/share/pool/simulations_collomics/cont2/cont2_{chrn2}.sam"
    output:
        bam2 = "bam_files/cont2_{chrn2}.bam"
    shell: """
        samtools view -b {input.sam2} -o {output.bam2} --threads 30
    """

## get HiFi reads
# set maximum resources for the rule
rule run_ccs_conta:
    input:
        bam = "bam_files/{cont_file}.bam"
    output:
        fastq = "fastq_files/{cont_file}.fastq.gz"
    resources:
        mem_mb=100000
    shell:
        "ccs {input.bam} {output.fastq} -j 5"
