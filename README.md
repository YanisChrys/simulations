# simulations
optimized for SGE cluster

## set up conda environment for simulations
```
conda create --name read_simulations
conda activate read_simulations
conda install mamba
mamba install -c conda-forge -c bioconda snakemake seqkit
```

### pbsim3:

Install as module (or whichever method is best for your system) from the [github repo](https://github.com/yukiteruono/pbsim3/releases/tag/v3.0.0)

### Do a dry run on 5 cores with:
```
snakemake -s snakemake_sims --dry-run --cores 5 -p -r -w 5 --verbose
```

## install packages:
The packages to be used by single rules need to be installed beforehand
Due to dependency conflicts, most programs, if they are to be used with conda, have to be installed as separate packages
If mamba isn't available from where you run this include the following option as well:
`--conda-frontend conda `
snakemake \
    --snakefile snakemake_sims \
    -j 5 \
    --use-envmodules \
    --use-conda \
    --conda-create-envs-only 
```

### Run on SGE cluster with 60 cores with:
```
qsub -pe smp 60 -q medium.q SGE_simulations.sh
```

### Create graph of jobs with:
```
snakemake -s PATH/TO/SMKFILE/snakemake_sims --dag --forceall | dot -Tpdf > graph_of_jobs.pdf
```

## Combine unplaced scaffolds into one entry to reduce number of output files
`combineUnplaced.sh`
takes each unplaced scaffold (hardcoded for vgp Taeniopygia guttata -- careful) and combine them by separating by 1000 Ns each time.

## BUSCO:

For BUSCO, it is preferable to use it `offline`. To do that, download the desired dataset from [here](https://busco-data.ezlab.org/v5/data/lineages/), unpack and place in folder with:
```
curl -O <link>
tar -xf <file> # becomes <folder>
mkdir busco_downloads
mkdir busco_downloads/lineages
mv <folder> busco_downloads/lineages
```


### Genomes to be used for asseblies can be downloaded from [here](https://genomeark.github.io/vgp-curated-assembly/)
