#!/bin/bash

gunzip EchD_R1.fastq.gz
gunzip EchD_R2.fastq.gz
mkdir resultats

# 1° Identification et quantification des bactéries
#	# Alignement des reads avec all.genome.fasta
./soft/bowtie2 --end-to-end --fast -x ./databases/all_genome.fasta -1 EchD_R1.fastq -2 EchD_R2.fastq -S ./resultats/EchD.sam




