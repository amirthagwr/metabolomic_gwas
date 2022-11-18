# Steps included in GWAS 

Linux workflow to perform GWAS on HPC platform
  - Genotype QC
  - PCA
  - Imputation
  - Association Testing
  
  
# Genotype QC

Raw data of the genotypes with .bed, .bim, .fam format can be added as an input for the submission of the QC bash script named **step1_preprocessing.sh**

# PCA

Merge 1K genome with your dataset as a reference panel 
and EIGENSOFT is a tool to calculate eigen values from the genotypes and the PCs are added as covariates.

Referece: https://www.hsph.harvard.edu/alkes-price/software/
- EIGENSOFT version 7.2.1 

Run **PCA_1kgp_merged_child.R** script to visualize the principal components 

# Imputation 

In order to predict the genotypes of whole genome, we can impute from the Haplotype Research Consortium available in </dd>
Michigan Imputation Server 
https://imputationserver.sph.umich.edu/index.html



# Association Testing 

Association of metabolite and genotype in linear regression model using PLINK commands

HPC submission for multiple metabolites:
```
for i in `cat metabolite.list`; do 
  sbatch gwas_submission.sh --export=metabolite_name=$i; done

```
This script will run the linear regression testing for each metabolite with the whole genome genotyping dataset and plot a manhattan plot for each one of them.



