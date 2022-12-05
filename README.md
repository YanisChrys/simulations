# simulations

## set up conda environment for simulations
```
conda create --name read_simulations
conda activate read_simulations
conda config --add channels conda-forge
conda config --add channels bioconda  
conda config --add channels agbiome 
conda install -y bbtools bbmap entrez-direct samtools pbccs hifiasm seqkit bbmap bwa bedtools r-essentials r-argparse r-ggplot2 picard r-scales r-viridis snakemake bcftools freebayes bam2fastx pairtools pairix r-base r-minpack.lm busco merqury openjdk=11
```

### pbsim3:

Install as module (or whichever method is best for your system) from the github [repo](https://github.com/yukiteruono/pbsim3/releases/tag/v3.0.0)

### Do a dry run on 5 cores with:
```
snakemake -s snakemake_sims --dry-run --cores 5 -p -r -w 5 --verbose
```


### Run on SGE cluster with 60 cores with:
```
qsub -pe smp 60 -q medium.q SGE_simulations.sh
```

### Create graph of jobs with:
```
snakemake -s PATH/TO/SMKFILE/snakemake_sims --dag --forceall | dot -Tpdf > graph_of_jobs.pdf
```
## BUSCO:

For BUSCO, it is preferable to use it `offline`. To do that, download the desired dataset from [here](https://busco-data.ezlab.org/v5/data/lineages/), unpack and place in folder with:
```
curl -O <link>
tar -xf <file> # becomes <folder>
mkdir busco_downloads
mkdir busco_downloads/lineages
mv <folder> busco_downloads/lineages
```


## Genomes to be used for assmeblies can be downloaded from [here](https://genomeark.github.io/vgp-curated-assembly/)
