#!/bin/bash
#SBATCH --job-name=gwas_metabolites
#SBATCH -c 4
#SBATCH --mem=32g
#SBATCH -t 100:00:00
#SBATCH -o ./logs/%j-%N-%x.out
#SBATCH -e ./logs/%j-%N-%x.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your_email_id

module load plink/1.9b_5.2-x86_64

### SET PARAMETERS ####################################################
job_name="gwas_metabolite" 
printf "job ${job_name} started at $(date) \n"
time1=$(date +%s)

plink_fname="genotype_dataset"
covariates_fname="pca_plus_other_covariates"

# static directories
input_data_dir="/global/project/xxx/rawdata"
GWAS_output_dir="/global/project/xxx/"


##########GWAS########################

plink --bfile ${input_data_dir} \ 
	--ci 0.95 \
  --covar {covariates_fname} \
  --linear hide-covar \
  --maf 0.05 \
  --out ${GWAS_output_dir}${metabolite_name} \
 --pheno ${metabolite_data} \
 --pheno-name $metabolite_name


R CMD BATCH forloop_rscript_manhattan_plot.r

time2=$(date +%s)
secs=$((time2-time1))
printf "job ${job_name} ended at "$(date)  
