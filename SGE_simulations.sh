#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -j n
#$ -q medium.q
#$ -N read_simulations
#$ -M i.chrysostomakis@leibniz-lib.de
#$ -m beas

# qsub -pe smp 60 -q medium.q SGE_simulations.sh 

module load anaconda3/2022.05
conda activate read_simulations

#one core will be used by snakemake to monitor the other processes

THREADS=$(expr ${NSLOTS} - 1)

snakemake \
    --snakefile snakemake_sims \
    --keep-going \
    --latency-wait 60 \
    -j ${THREADS} \
    --resources mem_mb=500000 \
    --verbose \
    --use-envmodules \
    --use-conda \
    --printshellcmds \
    --reason \
    --nolock \
    --conda-frontend conda 

#    --until run_sim_hap1

#    --rerun-triggers mtime
#    --use-conda \
#    --use-envmodules \
