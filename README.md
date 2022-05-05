# nf-core-pipeline-to-arc

WORK IN PROGRESS

Generates an ARC ready CWL workflow and run from a nf-core pipeline's `nextflow_schema.json`.

Basic commands:

```
tsc main.ts --resolveJsonModule
node main.js
```

After creating your pipeline.cwl, you can test it by running the test version of the respective pipeline. This implies you have `nextflow` and `cwltool` installed.

Command for test run:

```
cwltool pipeline.cwl minTest.yml
```
