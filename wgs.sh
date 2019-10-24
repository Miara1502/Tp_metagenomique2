#!/bin/bash

gunzip EchD_R1.fastq.gz
gunzip EchD_R2.fastq.gz
mkdir resultats

# 1° 2° Identification et quantification des bactéries

#	# Alignement des reads avec all.genome.fasta
./soft/bowtie2 --end-to-end --fast -x ./databases/all_genome.fasta -1 EchD_R1.fastq -2 EchD_R2.fastq -S ./resultats/EchD.sam

#	#Quantifier l'abondance de chaque bactérie

samtools view -b ./resultats/EchD.sam -1 -o ./resultats/EchD.bam
samtools sort ./resultats/EchD.bam -o ./resultats/EchD_sorted.bam
samtools index ./resultats/EchD_sorted.bam
samtools idxstats ./resultats/EchD_sorted.bam
samtools idxstats ./resultats/EchD_sorted.bam > ./resultats/comptage.txt
grep ">" ./databases/all_genome.fasta|cut -f 2 -d ">" > ./resultats/association.tsv


# 3° 
