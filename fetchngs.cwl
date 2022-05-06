#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

requirements: []

inputs:
- id: input
  type: string?
  inputBinding:
    prefix: --input
- id: ena_metadata_fields
  type: string?
  inputBinding:
    prefix: --ena_metadata_fields
- id: sample_mapping_fields
  type: string?
  default: |-
    run_accession,sample_accession,experiment_alias,run_alias,sample_alias,experiment_title,sample_title,sample_description,description
  inputBinding:
    prefix: --sample_mapping_fields
- id: nf_core_pipeline
  type: string?
  inputBinding:
    prefix: --nf_core_pipeline
- id: skip_fastq_download
  type: boolean?
  inputBinding:
    prefix: --skip_fastq_download
- id: outdir
  type: string?
  default: ./results
  inputBinding:
    prefix: --outdir
- id: email
  type: string?
  inputBinding:
    prefix: --email
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
- id: hostnames
  type: string?
  inputBinding:
    prefix: --hostnames
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
- id: monochrome_logs
  type: boolean?
  inputBinding:
    prefix: --monochrome_logs
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
- id: singularity_pull_docker_container
  type: boolean?
  inputBinding:
    prefix: --singularity_pull_docker_container
- id: release
  type: string?
  default: 1.3
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
    glob: $(inputs.outdir)

baseCommand:
- nextflow
- run
- nf-core/fetchngs

hints: []
