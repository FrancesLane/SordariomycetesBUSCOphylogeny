#!/bin/bash

# Script to automate the generation of BUSCOs to create a phylogenetic tree
# Created 02 May 2023 Frances Lane

# This script will run BUSCO, but will make use of reference genes of the first isoform present in your lineage of choice.
# This will allow you to make a phylogenetic tree from these prediced BUSCO genes.

## Copy this script into the same directory as your genome assemblies.
## If needed, do this to any of the scripts to make them executable:
## >chmod u+x [filename].
## All genomes must have the extension .fasta. To change other extensions, you can use a script like the one below in the genomes dorectory (this one converts .fa files to .fasta):

#for genome in *.fa; do
#    mv "$genome" "${genome%.fa}.fasta"
#done

## Unzip your lineage into the directory ~/resources/busco_downloads.
## Enter the exact name of this lineage below (I have used sordariomycetes_odb10)
lineage=sordariomycetes_odb10

## run this script by typing ./runBUSCOforTree.sh

echo Removing multiple isoforms from $lineage reference sequences...

mkdir ~/resources/busco_downloads/for_tree_"$lineage"
cp -r ~/resources/busco_downloads/$lineage/* ~/resources/busco_downloads/for_tree_"$lineage"
rm ~/resources/busco_downloads/for_tree_"$lineage"/refseq_db.faa.gz
gzip -d ~/resources/busco_downloads/$lineage/refseq_db.faa.gz
awk '/^>/ && !/_/ {print; getline; print}' ~/resources/busco_downloads/$lineage/refseq_db.faa > ~/resources/busco_downloads/for_tree_"$lineage"/refseq_db.faa
gzip ~/resources/busco_downloads/$lineage/refseq_db.faa
gzip ~/resources/busco_downloads/for_tree_"$lineage"/refseq_db.faa

echo $lineage reference sequences edited.
echo
echo '<><><><><><><><>><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'
echo

echo Running BUSCO...
echo
for assembly in *.fasta; do

BUSCO.py -c 4 -m geno \
       -i $assembly \
       -l ~/resources/busco_downloads/for_tree_"$lineage" \
       -o $assembly.busco

echo BUSCO complete for $assembly.
echo
echo '<><><><><><><><>><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'
echo
done

mkdir input_assemblies
mkdir busco_output
mv *.fasta ./input_assemblies
mv *.busco ./busco_output

echo BUSCO complete for all genome assemblies.
