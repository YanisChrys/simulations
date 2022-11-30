#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -j n
#$ -q medium.q
#$ -N read_simulations
#$ -M i.chrysostomakis@leibniz-lib.de
#$ -m beas

# qsub -pe smp 60 -q medium.q SGE_genome_assembly.sh

module load anaconda3/2022.05

conda activate read_simulations

#one core will be used by snakemake to monitor the other processes

THREADS=$(expr ${NSLOTS} - 1)

snakemake \
    --snakefile snakemake_sims \
    --keep-going \
    --latency-wait 60 \
    --conda-frontend conda \
    --cores ${THREADS} \
    --verbose \
    --use-conda \
    --printshellcmds \
    --reason \
    --nolock 
#    --conda-create-envs-only \
#    --rerun-triggers mtime
#    --use-conda \
#    --use-envmodules \
