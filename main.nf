#!/usr/bin/env nextflow
import java.nio.file.Paths

// Folder with *.bam and *.bai files
bam_folder="$params.input_bucket/$params.run_folder_id"
output_folder="$params.output_bucket/$params.output_folder"
snp_file = "$params.assets_bucket/$params.snp_vcf_file"

// Read in bam/bai files
tumour_bam = file("$bam_folder/$params.tumour_bam/$params.tumour_bam*.bam")[0]
tumour_bai = file("$bam_folder/$params.tumour_bam/$params.tumour_bam*.bam.bai")[0]


