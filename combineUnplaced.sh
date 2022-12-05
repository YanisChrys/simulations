#!/bin/bash

##### Hardcoded bash file to combine all unplaced scaffolds of assembly and separate them by Ns
##### for primary assembly and and mutated primary assembly (haplotype 1 and 2)

# consider using samtools faidx on both files first
samtools faidx bTaeGut1.pri.cur.20210409.fasta
samtools faidx mutated.fasta

# save chromosome and unplaced scaffold names into text files and remove ">" ( required input for samtools faidx -r )
# repeat for mutated file
cat bTaeGut1.pri.cur.20210409.fasta | grep ">SUPER_" | sed 's/>//' > chroms.pri.txt 
cat bTaeGut1.pri.cur.20210409.fasta | grep ">scaffold_" | sed 's/>//' > scaffolds.pri.txt 

cat mutated.fasta | grep ">SUPER_" | sed 's/>//' > chroms.alt.txt 
cat mutated.fasta | grep ">scaffold_" | sed 's/>//' > scaffolds.alt.txt 


# extract chromosomes and create new "chromosome" header for all unplaced scaffolds
samtools faidx bTaeGut1.pri.cur.20210409.fasta -r chroms.pri.txt > bTaeGut1.pri.fasta && \
echo ">unplaced" >> bTaeGut1.pri.fasta &

samtools faidx mutated.fasta -r chroms.alt.txt > mutated.loop.fasta && \
echo ">unplaced" >> mutated.loop.fasta &

# create a variable with 1000 Ns 
len=1000
ch='N'
appendNs=$(printf '%*s' "$len" | tr ' ' "$ch" )

# extract scaffold from original fasta, remove header and append to the fasta with chroms only
# remove eof after each append so the file can be folded well at the end
# append Ns 
# finally fold
for scaffold in $(cat scaffolds.pri.txt)
do
    samtools faidx bTaeGut1.pri.cur.20210409.fasta $scaffold | awk NR\>1 >> bTaeGut1.pri.fasta
    perl -pi -e 'chomp if eof' bTaeGut1.pri.fasta
    echo $appendNs >> bTaeGut1.pri.fasta 
    perl -pi -e 'chomp if eof' bTaeGut1.pri.fasta
done

for scaffold in $(cat scaffolds.alt.txt)
do
    samtools faidx mutated.fasta $scaffold | awk NR\>1 >> mutated.loop.fasta
    perl -pi -e 'chomp if eof' mutated.loop.fasta
    echo $appendNs >> mutated.loop.fasta 
    perl -pi -e 'chomp if eof' mutated.loop.fasta
done

seqkit seq -w 60 bTaeGut1.pri.fasta > bTaeGut1.pri.final.fasta
seqkit seq -w 60 mutated.loop.fasta > mutated.final.fasta

# index files
samtools faidx bTaeGut1.pri.final.fasta && \
samtools faidx mutated.final.fasta &

# check your fasta files:
seqkit stats bTaeGut1.pri.final.fasta && \
seqkit stats mutated.final.fasta &


# you might want to remove all other fasta files...