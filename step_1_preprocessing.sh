#!/bin/bash
#SBATCH --job-name=gwas_preprocessing
#SBATCH -c 4
#SBATCH --mem=32g
#SBATCH -t 100:00:00
#SBATCH -o ./logs/%j-%N-%x.out
#SBATCH -e ./logs/%j-%N-%x.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your_email_id

module load plink/1.9b_5.2-x86_64

### SET PARAMETERS ####################################################
job_name="preprocessing_genome_wide" 
printf "job ${job_name} started at $(date) \n"
time1=$(date +%s)

plink_fname="genotype_dataset"

# static directories
raw_data_dir="/global/project/xxx/rawdata"
GWAS_output_dir="/global/project/xxx/"
prep_output_dir="/global/project/xxx/outputs"



#########PREPROCESSING#####

plink --bfile ${raw_data_dir}${plink_fname} \
	--sex-check \
	--out ${prep_output_dir}${plink_fname}

grep "PROBLEM" ${prep_output_dir}${plink_fname}.sexcheck | cut -f 1,2 >samples_to_remove.txt

plink --bfile ${raw_data_dir}${plink_fname} \
	--remove samples_to_remove.txt \
	--make-bed --out ${prep_output_dir}${plink_fname}_subjectsremoved

plink --bfile ${prep_output_dir}${plink_fname}_subjectsremoved \
	--het \ 
	--out ${prep_output_dir}${plink_fname}_heterozygosity

plink --bfile ${prep_output_dir}${plink_fname}_subjectsremoved \
	--missing \
	--out ${prep_output_dir}${plink_fname}_missingness

R CMD BATCH imiss-vs-het_subjects.R

plink --bfile ${prep_output_dir}${plink_fname}_subjectsremoved \
	--remove fail_imiss_heterozygosity_subjects.txt \
	--make-bed --out ${prep_output_dir}${plink_fname}_sex_het_imiss_removed


plink --bfile ${prep_output_dir}${plink_fname}_sex_het_imiss_removed \
	 --indep-pairwise 50 5 0.6 \
	--out ${prep_output_dir}${plink_fname}_sex_het_imiss_removed_pruning 

plink --bfile ${prep_output_dir}${plink_fname}_sex_het_imiss_removed \
	--extract ${prep_output_dir}${plink_fname}_sex_het_imiss_removed_pruning.prune.in \
	--genome \
	--out ${prep_output_dir}${plink_fname}_sex_het_imiss_removed_ibd_check

perl run-IBD-QC_WT_UK.pl > fail-IBD-QC_subjects.txt

plink --bfile ${prep_output_dir}${plink_fname}_sex_het_imiss_removed \
	--remove fail-IBD-QC_subjects.txt \
	--make-bed --out ${prep_output_dir}${plink_fname}_sex_het_imiss_IBD_removed

plink --bfile ${prep_output_dir}${plink_fname}_sex_het_imiss_IBD_removed \
	--geno 0.05 \
	--make-bed --out ${prep_output_dir}${plink_fname}_preprocessed


time2=$(date +%s)
secs=$((time2-time1))
printf "job ${job_name} ended at "$(date)


