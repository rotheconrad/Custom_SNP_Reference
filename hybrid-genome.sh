#!/bin/bash

#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4gb

module load samtools

Sorted=`ls *.sam | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`
Sorted_out=`echo $Sorted | cut -d. -f1-3`.mpileup.vcf

samtools mpileup -u -B -v -q 30 -f Ceratodon_purpureus.main_genome.scaffolds.sorted.fa -o $Sorted_out $Sorted.sorted.bam

module load bcftools

bcf_out=`echo $Sorted | cut -d. -f1-3`.bcfcalls.vcf

bcftools call -m -V indels -o $bcf_out $Sorted_out

module load gatk

GATK_out=`echo $Sorted | cut -d. -f1-2`.hybrid_genome.fasta

java -jar $HPC_GATK_DIR/GenomeAnalysisTK.jar -T FastaAlternateReferenceMaker -R Ceratodon_purpureus.main_genome.scaffolds.sorted.fa -V $bcf_out -o $GATK_out

perl Scripts/fasta_alternate_reference_maker_renamer.pl $GATK_out
