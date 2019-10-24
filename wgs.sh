#!/bin/bash

gunzip EchG_R1.fastq.gz
gunzip EchG_R2.fastq.gz
mkdir resultats

# 1° 2° Identification et quantification des bactéries

#	# Alignement des reads avec all.genome.fasta
./soft/bowtie2 --end-to-end --fast -x ./databases/all_genome.fasta -1 EchG_R1.fastq -2 EchG_R2.fastq -S ./resultats/EchG.sam

#	#Quantifier l'abondance de chaque bactérie

samtools view -b ./resultats/EchG.sam -1 -o ./resultats/EchG.bam
samtools sort ./resultats/EchG.bam -o ./resultats/EchG_sorted.bam
samtools index ./resultats/EchG_sorted.bam
samtools idxstats ./resultats/EchG_sorted.bam
samtools idxstats ./resultats/EchG_sorted.bam > ./resultats/comptage.txt
grep ">" ./databases/all_genome.fasta|cut -f 2 -d ">" > ./resultats/association.tsv


# 3° Assemblage du génome des bactéries avec MEGAHIT avec une seule taille
#    de KMER 21
./soft/megahit -1 EchG_R1.fastq -2 EchG_R2.fastq --k-max 21 --memory 0.4 -o ./resultats/res_megahit

# 4° Prédiction des gènes présents sur les contigs avec prodigal : 
./soft/prodigal -i ./resultats/res_megahit/final.contigs.fa -d ./resultats/genes.fna

# 5° Séléction des genes complets
sed "s:>:*\n>:g" ./resultats/genes.fna | sed -n "/partial=00/,/*/p"|grep -v "*" > ./resultats/genes_complet.fna 


# 6° Annotation des gènes “complets” contre la banque resfinder avec blastn
./soft/blastn -query ./resultats/genes_complet.fna -db ./databases/resfinder.fna -outfmt '6 qseqid sseqid pident qcovs evalue' -out ./resultats/annotation_blast.out -evalue 0.001 -qcov_hsp_perc 80 -perc_identity 80 -best_hit_score_edge 0.001

#Est ce que vos génomes présentes des gènes de résistance pour certains #antibiotiques ? 

# réponse : 
# oui , L échantillon G présente 31 gènes de résistance pour des antibiotiques






 


