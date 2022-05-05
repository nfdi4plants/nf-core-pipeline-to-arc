{"class":"CommandLineTool","inputs":[{"id":"input","type":"string?","inputBinding":{"prefix":"--input"}},{"id":"input_type","default":"sra","type":"string?","inputBinding":{"prefix":"--input_type"}},{"id":"ena_metadata_fields","type":"string?","inputBinding":{"prefix":"--ena_metadata_fields"}},{"id":"sample_mapping_fields","default":"experiment_accession,run_accession,sample_accession,experiment_alias,run_alias,sample_alias,experiment_title,sample_title,sample_description,description","type":"string?","inputBinding":{"prefix":"--sample_mapping_fields"}},{"id":"nf_core_pipeline","type":"string?","inputBinding":{"prefix":"--nf_core_pipeline"}},{"id":"force_sratools_download","type":"boolean?","inputBinding":{"prefix":"--force_sratools_download"}},{"id":"skip_fastq_download","type":"boolean?","inputBinding":{"prefix":"--skip_fastq_download"}},{"id":"outdir","default":"./results","type":"string?","inputBinding":{"prefix":"--outdir"}},{"id":"email","type":"string?","inputBinding":{"prefix":"--email"}},{"id":"synapse_config","type":"string?","inputBinding":{"prefix":"--synapse_config"}},{"id":"custom_config_version","default":"master","type":"string?","inputBinding":{"prefix":"--custom_config_version"}},{"id":"custom_config_base","default":"https://raw.githubusercontent.com/nf-core/configs/master","type":"string?","inputBinding":{"prefix":"--custom_config_base"}},{"id":"config_profile_name","type":"string?","inputBinding":{"prefix":"--config_profile_name"}},{"id":"config_profile_description","type":"string?","inputBinding":{"prefix":"--config_profile_description"}},{"id":"config_profile_contact","type":"string?","inputBinding":{"prefix":"--config_profile_contact"}},{"id":"config_profile_url","type":"string?","inputBinding":{"prefix":"--config_profile_url"}},{"id":"max_cpus","default":16,"type":"int?","inputBinding":{"prefix":"--max_cpus"}},{"id":"max_memory","default":"128.GB","type":"string?","inputBinding":{"prefix":"--max_memory"}},{"id":"max_time","default":"240.h","type":"string?","inputBinding":{"prefix":"--max_time"}},{"id":"help","type":"boolean?","inputBinding":{"prefix":"--help"}},{"id":"email_on_fail","type":"string?","inputBinding":{"prefix":"--email_on_fail"}},{"id":"plaintext_email","type":"boolean?","inputBinding":{"prefix":"--plaintext_email"}},{"id":"monochrome_logs","type":"boolean?","inputBinding":{"prefix":"--monochrome_logs"}},{"id":"tracedir","default":"${params.outdir}/pipeline_info","type":"string?","inputBinding":{"prefix":"--tracedir"}},{"id":"validate_params","default":true,"type":"boolean?","inputBinding":{"prefix":"--validate_params"}},{"id":"show_hidden_params","type":"boolean?","inputBinding":{"prefix":"--show_hidden_params"}},{"id":"enable_conda","type":"boolean?","inputBinding":{"prefix":"--enable_conda"}},{"id":"release","default":3.6,"type":"float?","inputBinding":{"prefix":"-r"}},{"id":"profile","default":"singularity","type":"string?","inputBinding":{"prefix":"-profile"}}],"outputs":[{"id":"out_folder","type":"Directory","outputBinding":{"glob":"$(inputs.outdir)"}}],"requirements":[],"hints":[],"cwlVersion":"v1.2","baseCommand":["nextflow","run","nf-core/rnaseq"]}