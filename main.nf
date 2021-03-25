#!/usr/bin/env nextflow
import java.nio.file.Paths

// Folder with *.bam and *.bai files
bam_folder="$params.input_bucket/$params.run_folder_id"
output_folder="$params.output_bucket/$params.output_folder"
snp_file = file("s3://dperera-orchestration-ch/inputs/00-common_all.vcf")[0]

// Read in bam/bai files
tumour_bam = file("$bam_folder/$params.tumour_bam/$params.tumour_bam*.bam")[0]
tumour_bai = file("$bam_folder/$params.tumour_bam/$params.tumour_bam*.bam.bai")[0]

normal_bam = file("$bam_folder/$params.normal_bam/$params.normal_bam*.bam")[0]
normal_bai = file("$bam_folder/$params.normal_bam/$params.normal_bam*.bam.bai")[0]


process run_FACETS{
    publishDir output_folder, mode: 'copy'
    
    disk '50 GB'
    memory = 15.GB
    cpus = 8
    input:
        file tumour_bam
        file tumour_bai
        file normal_bam
        file normal_bai
        file snp_file
        
    output:
        file  "*.tar.gz"

    """
    snp-pileup-wrapper.R -vcf ${snp_file} -n ${normal_bam} -t ${tumour_bam} --output-prefix ${params.sample}
    run-facets-wrapper.R --counts-file ${params.sample}.snp_pileup.gz --sample-id ${params.sample} --purity-cval 1000 --cval 500 --everything
    tar cvzf ${params.sample}.tar.gz ${params.sample}
    """
}
