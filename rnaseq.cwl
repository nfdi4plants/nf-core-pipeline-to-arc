#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

requirements: []

inputs:
- id: input
  type: string?
  inputBinding:
    prefix: --input
- id: outdir
  type: string?
  inputBinding:
    prefix: --outdir
- id: email
  type: string?
  inputBinding:
    prefix: --email
- id: multiqc_title
  type: string?
  inputBinding:
    prefix: --multiqc_title
- id: save_merged_fastq
  type: boolean?
  inputBinding:
    prefix: --save_merged_fastq
- id: with_umi
  type: boolean?
  inputBinding:
    prefix: --with_umi
- id: umitools_extract_method
  type: string?
  default: string
  inputBinding:
    prefix: --umitools_extract_method
- id: umitools_bc_pattern
  type: string?
  inputBinding:
    prefix: --umitools_bc_pattern
- id: umi_discard_read
  type: int?
  inputBinding:
    prefix: --umi_discard_read
- id: save_umi_intermeds
  type: boolean?
  inputBinding:
    prefix: --save_umi_intermeds
- id: bbsplit_fasta_list
  type: string?
  inputBinding:
    prefix: --bbsplit_fasta_list
- id: bbsplit_index
  type: string?
  inputBinding:
    prefix: --bbsplit_index
- id: save_bbsplit_reads
  type: boolean?
  inputBinding:
    prefix: --save_bbsplit_reads
- id: skip_bbsplit
  type: boolean?
  default: true
  inputBinding:
    prefix: --skip_bbsplit
- id: remove_ribo_rna
  type: boolean?
  inputBinding:
    prefix: --remove_ribo_rna
- id: ribo_database_manifest
  type: string?
  default: |-
    https://raw.githubusercontent.com/nf-core/rnaseq/master/assets/rrna-db-defaults.txt
  inputBinding:
    prefix: --ribo_database_manifest
- id: save_non_ribo_reads
  type: boolean?
  inputBinding:
    prefix: --save_non_ribo_reads
- id: genome
  type: string?
  inputBinding:
    prefix: --genome
- id: fasta
  type: string?
  inputBinding:
    prefix: --fasta
- id: gtf
  type: string?
  inputBinding:
    prefix: --gtf
- id: gff
  type: string?
  inputBinding:
    prefix: --gff
- id: gene_bed
  type: string?
  inputBinding:
    prefix: --gene_bed
- id: transcript_fasta
  type: string?
  inputBinding:
    prefix: --transcript_fasta
- id: additional_fasta
  type: string?
  inputBinding:
    prefix: --additional_fasta
- id: splicesites
  type: string?
  inputBinding:
    prefix: --splicesites
- id: star_index
  type: string?
  inputBinding:
    prefix: --star_index
- id: hisat2_index
  type: string?
  inputBinding:
    prefix: --hisat2_index
- id: rsem_index
  type: string?
  inputBinding:
    prefix: --rsem_index
- id: salmon_index
  type: string?
  inputBinding:
    prefix: --salmon_index
- id: hisat2_build_memory
  type: string?
  default: 200.GB
  inputBinding:
    prefix: --hisat2_build_memory
- id: gencode
  type: boolean?
  inputBinding:
    prefix: --gencode
- id: gtf_extra_attributes
  type: string?
  default: gene_name
  inputBinding:
    prefix: --gtf_extra_attributes
- id: gtf_group_features
  type: string?
  default: gene_id
  inputBinding:
    prefix: --gtf_group_features
- id: featurecounts_group_type
  type: string?
  default: gene_biotype
  inputBinding:
    prefix: --featurecounts_group_type
- id: featurecounts_feature_type
  type: string?
  default: exon
  inputBinding:
    prefix: --featurecounts_feature_type
- id: save_reference
  type: boolean?
  inputBinding:
    prefix: --save_reference
- id: igenomes_base
  type: string?
  default: s3://ngi-igenomes/igenomes
  inputBinding:
    prefix: --igenomes_base
- id: igenomes_ignore
  type: boolean?
  inputBinding:
    prefix: --igenomes_ignore
- id: clip_r1
  type: int?
  inputBinding:
    prefix: --clip_r1
- id: clip_r2
  type: int?
  inputBinding:
    prefix: --clip_r2
- id: three_prime_clip_r1
  type: int?
  inputBinding:
    prefix: --three_prime_clip_r1
- id: three_prime_clip_r2
  type: int?
  inputBinding:
    prefix: --three_prime_clip_r2
- id: trim_nextseq
  type: int?
  inputBinding:
    prefix: --trim_nextseq
- id: skip_trimming
  type: boolean?
  inputBinding:
    prefix: --skip_trimming
- id: save_trimmed
  type: boolean?
  inputBinding:
    prefix: --save_trimmed
- id: aligner
  type: string?
  default: star_salmon
  inputBinding:
    prefix: --aligner
- id: pseudo_aligner
  type: string?
  inputBinding:
    prefix: --pseudo_aligner
- id: bam_csi_index
  type: boolean?
  inputBinding:
    prefix: --bam_csi_index
- id: star_ignore_sjdbgtf
  type: boolean?
  inputBinding:
    prefix: --star_ignore_sjdbgtf
- id: salmon_quant_libtype
  type: string?
  inputBinding:
    prefix: --salmon_quant_libtype
- id: min_mapped_reads
  type: int?
  default: 5
  inputBinding:
    prefix: --min_mapped_reads
- id: seq_center
  type: string?
  inputBinding:
    prefix: --seq_center
- id: stringtie_ignore_gtf
  type: boolean?
  inputBinding:
    prefix: --stringtie_ignore_gtf
- id: save_unaligned
  type: boolean?
  inputBinding:
    prefix: --save_unaligned
- id: save_align_intermeds
  type: boolean?
  inputBinding:
    prefix: --save_align_intermeds
- id: skip_markduplicates
  type: boolean?
  inputBinding:
    prefix: --skip_markduplicates
- id: skip_alignment
  type: boolean?
  inputBinding:
    prefix: --skip_alignment
- id: rseqc_modules
  type: string?
  default: |-
    bam_stat,inner_distance,infer_experiment,junction_annotation,junction_saturation,read_distribution,read_duplication
  inputBinding:
    prefix: --rseqc_modules
- id: deseq2_vst
  type: boolean?
  inputBinding:
    prefix: --deseq2_vst
- id: skip_bigwig
  type: boolean?
  inputBinding:
    prefix: --skip_bigwig
- id: skip_stringtie
  type: boolean?
  inputBinding:
    prefix: --skip_stringtie
- id: skip_fastqc
  type: boolean?
  inputBinding:
    prefix: --skip_fastqc
- id: skip_preseq
  type: boolean?
  inputBinding:
    prefix: --skip_preseq
- id: skip_dupradar
  type: boolean?
  inputBinding:
    prefix: --skip_dupradar
- id: skip_qualimap
  type: boolean?
  inputBinding:
    prefix: --skip_qualimap
- id: skip_rseqc
  type: boolean?
  inputBinding:
    prefix: --skip_rseqc
- id: skip_biotype_qc
  type: boolean?
  inputBinding:
    prefix: --skip_biotype_qc
- id: skip_deseq2_qc
  type: boolean?
  inputBinding:
    prefix: --skip_deseq2_qc
- id: skip_multiqc
  type: boolean?
  inputBinding:
    prefix: --skip_multiqc
- id: skip_qc
  type: boolean?
  inputBinding:
    prefix: --skip_qc
- id: custom_config_version
  type: string?
  default: master
  inputBinding:
    prefix: --custom_config_version
- id: custom_config_base
  type: string?
  default: https://raw.githubusercontent.com/nf-core/configs/master
  inputBinding:
    prefix: --custom_config_base
- id: config_profile_name
  type: string?
  inputBinding:
    prefix: --config_profile_name
- id: config_profile_description
  type: string?
  inputBinding:
    prefix: --config_profile_description
- id: config_profile_contact
  type: string?
  inputBinding:
    prefix: --config_profile_contact
- id: config_profile_url
  type: string?
  inputBinding:
    prefix: --config_profile_url
- id: max_cpus
  type: int?
  default: 16
  inputBinding:
    prefix: --max_cpus
- id: max_memory
  type: string?
  default: 128.GB
  inputBinding:
    prefix: --max_memory
- id: max_time
  type: string?
  default: 240.h
  inputBinding:
    prefix: --max_time
- id: help
  type: boolean?
  inputBinding:
    prefix: --help
- id: publish_dir_mode
  type: string?
  default: copy
  inputBinding:
    prefix: --publish_dir_mode
- id: email_on_fail
  type: string?
  inputBinding:
    prefix: --email_on_fail
- id: plaintext_email
  type: boolean?
  inputBinding:
    prefix: --plaintext_email
- id: max_multiqc_email_size
  type: string?
  default: 25.MB
  inputBinding:
    prefix: --max_multiqc_email_size
- id: monochrome_logs
  type: boolean?
  inputBinding:
    prefix: --monochrome_logs
- id: multiqc_config
  type: string?
  inputBinding:
    prefix: --multiqc_config
- id: tracedir
  type: string?
  default: ${params.outdir}/pipeline_info
  inputBinding:
    prefix: --tracedir
- id: validate_params
  type: boolean?
  default: true
  inputBinding:
    prefix: --validate_params
- id: show_hidden_params
  type: boolean?
  inputBinding:
    prefix: --show_hidden_params
- id: enable_conda
  type: boolean?
  inputBinding:
    prefix: --enable_conda
- id: release
  type: float?
  default: 3.6
  inputBinding:
    prefix: -r
- id: profile
  type: string?
  default: singularity
  inputBinding:
    prefix: -profile

outputs:
- id: out_folder
  type: Directory
  outputBinding:
    glob: inputs.outdir

baseCommand:
- nextflow
- run
- nf-core/rnaseq

hints: []
