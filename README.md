These scripts can be used to generate a robust  phylogenetic tree using BUSCO genes predicted in 
Sordariomycete genome assemblies. The phylogeny will be based on a set of BUSCO genes present in input 
genome assemblies. BUSCO genes are first predicted (v. 2.0.1; SIMÃO et al. 2015) in all genome
assemblies using the sordariomycetes_odb10 lineage BUSCO library that is filtered to include only the
first isoform per reference gene. BUSCO genes predicted in all input genome assemblies are then 
concatenated and the nucleotide sequences are aligned using MAFFT (v. 7.407; KATOH AND STANDLEY 2013), 
after which the alignments are trimmed with TrimAl (v. 1.4.rev22; CAPELLA-GUTIERREZ et al. 2009). The 
trimmed alignments can then be concatenated using FASconCAT-G (v. 1.05.1; KÜCK AND LONGO 2014) followed 
by construction of the phylogeny using tools such as IQTree2 (v. 2.2.5; CHERNOMOR et al. 2016;
KALYAANAMOORTHY et al. 2017). 

Downloading all scripts into the directory containing the genome assemblies that will be input. To ensure
all scripts are executable, run the following script:

chmod u+x *.sh

All genome assemblies should be fasta files with the file extension ".fasta". If not, the following
command can be used to easily change all file extensions (replace [.extension] with the current 
file extension that needs to be changed):

for genome in *[.extension]; do
  mv "$genome" "${genome%.fa}.fasta"
done

Download the sordariomycetes_odb10 and unzip the lineage into the directory ~/resources/busco_downloads.
If the use of other lineages is desired, adaptations to the script may need to be made as the format of
the reference gene files can differ. 

Run the runBUSCOforTree.sh script to produce a filtered version of the sordariomycetes_odb10 dataset
and to perform BUSCO on every genome assembly in the directory - this can take a very long time.
Once complete, all input genome assemblies will be moved into the directory input_assemblies, and 
all BUSCO results will be moved to the busco_output directory.

To concatenate BUSCO genes present in all genome assemblies, the runCatFilter.sh script must be run.
NB! First edit this script by changing "genome=[number_of_genomes]" (line 13) to the number of 
genome assemblies in your dataset. 

Executing runCatFilter.sh will first concatenate all BUSCO genes (in directory 
concatenated_genes/all_genes), and then filter this output to produce a list of genes present in all 
genome assemblies (in directory concatenated_genes/filtered_genes).
Once complete, the number of genes present in all genome assemblies that will be used to make the 
phylogeny will be printed and can also be found in gene_number.txt.

Excute runMAFFT_TrimAL.sh to produce gene alignments and trim these alignments. Outputs that should be used
for FASconCAT-G can be found in directory aligned/trimmed.
