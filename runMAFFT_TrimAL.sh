#!/bin/bash

# Script to run MAFFT on all sequences in filtered_genes directory
# Created 21 February 2023 Frances Lane
# Run this script from directory one up from your concatenated_genes directory
# Output will be two directories back in the directory called "aligned"

mkdir aligned
mkdir aligned/original
mkdir aligned/trimmed
mkdir aligned/edited


# Running MAFFT

cd concatenated_genes/filtered_genes/
for filename in *.fna; do
mafft --thread 2 --reorder --adjustdirection --maxiterate 1000 --auto $filename > ../../aligned/original/${filename%}
echo '<><><><><><><><>><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'
echo $filename alignment complete
echo '<><><><><><><><>><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'
echo
done
echo All alignments complete
echo
echo '<><><><><><><><>><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'
echo

# Changing fasta sequence ID so that they are all the genome names which is needed for FASconCAT

for file in *.fna; do
sed 's/.fasta:.*//' ../../aligned/original/$file | sed 's/>.*:/>/' > ../../aligned/edited/$file.fas
done
echo Fasta sequence IDs edited.
echo
echo '<><><><><><><><>><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>'
echo

# Using TrimAl to remove gappy regions as it says in the slides from Martin
echo Running TrimAl...
cd ../../aligned/edited
for x in *.fas; do
trimal -gappyout -in $x -out ../trimmed/trim_$x
done
echo
echo TrimAl completed
