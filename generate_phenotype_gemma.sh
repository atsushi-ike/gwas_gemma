# First argument => name of rda object
# Second argument => name of context
# Third argument => region
# Fourth argument => accessions_order file

# The script can be run from another directory as long as dependent scripts are located in same directory as caller script (i.e. this script)

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)

generate_phenotype_gemma(){
	rda_object=$1
	name_df=${1%.rda}
	context=$2
	region=$3
	gemma_file=${context}_${region}.tsv
	accessions_order=${4}
	
	# echo $rda_object
	# echo $name_df
	# echo $context
	# echo $gemma_file
	
	# Make readable dataframe for 1 methylation context
	echo "Rscript subset_df_methylation.R $context $rda_object ${name_df}.txt"
	Rscript ${ABSDIR}/subset_df_methylation.R $context $rda_object ${name_df}.txt
	
	# Generate a file with only methylation data, in the order specified in the VCF file used for GWAS
	echo "Rscript create_gemma_phenotype.R $accessions_order df_accessions.txt ${name_df}.txt $gemma_file"
	Rscript ${ABSDIR}/create_gemma_phenotype.R $accessions_order df_accessions.txt ${name_df}.txt $gemma_file
	
}

# Example:
# generate_phenotype_gemma df_mean_intergenic_regions.rda CHH intergenic_regions order_accessions.txt
generate_phenotype_gemma $1 $2 $3 $4
