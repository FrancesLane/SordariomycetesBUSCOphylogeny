#!/bin/bash

# Script to concatenate and filter BUSCO genes for alignment
# Created 21 February 2023 Frances Lane
# Updated 13 July 2023

# NB! Read and edit ## comment on line 29
# Run this from the diretory one level up from /busco_outputs (same place where runBUSCOforTree is)

## !!!NB!!!  
## Change genome value to number of genomes that you are working on

genome=42

echo Concatenating genes...

# Creating list of all BUSCO genes predicted from all genomes
touch list
for gene in busco_output/*.busco/single_copy_busco_sequences/; do
ls $gene*fna | sed 's\'$gene'\\g' >> list
done

# Removing duplicates in the list
sort -u list > genes
rm list

# Concatenating fasta files of the same genes using previous list to pull them
mkdir concatenated_genes
mkdir concatenated_genes/all_genes
mkdir concatenated_genes/filtered_genes

while read name; do
  find -type f -name $name -exec cat {} \; > concatenated_genes/all_genes/cat_$name
echo Concatenated $name.
done < genes
rm genes
echo All genes concatenated.
echo
echo '<><><><><><><><>><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'
echo

# Filtering to genes that are present in all genomes

echo Filtering genes to those present in all $genome genomes...

for x in concatenated_genes/all_genes/*; do
    if [ $(grep ">" "$x" | sort -u | grep -c ">") -eq $genome ] && [ $(grep -c ">" "$x") -eq $genome ]; then
        cp "$x" ./concatenated_genes/filtered_genes
    fi
done

echo
echo Filtering complete.
echo
echo There are $(find concatenated_genes/filtered_genes/ -maxdepth 1 -type f | wc -l) genes present in all $genome genomes.
echo There are $(find concatenated_genes/filtered_genes/ -maxdepth 1 -type f | wc -l) genes present in all $genome genomes. > gene_number.txt