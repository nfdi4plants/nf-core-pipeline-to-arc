import * as cwlTsAuto from "cwl-ts-auto";
import * as fs from "fs";
import * as https from "https";

/* ********************************************* */
// GET PIPELINE INFO FROM USER BY CONSOLE INPUT //
/* ******************************************** */
const prompt = require("prompt-sync")({ sigint: true });
const pipeline = prompt("Enter the pipelines name (e.g. nf-core/rnaseq): ");
const version = prompt("Enter the pipeline version used (e.g. 3.5): ");
const outname = prompt("Enter the name of your output .cwl (e.g. rnaseq): ");

/* ************************************************************* */
// DOWNLOAD THE NEXTFLOW_SCHEMA.JSON FROM PIPELINE'S GITHUB REPO //
// AND EXTRACT INFORMATION FOR THE .CWL FILE                     //
/* ************************************************************ */
// path to github content
const gitpath = "https://raw.githubusercontent.com/";
// create path to nextflow_schema.json
const schemapath = gitpath + pipeline + "/" + version + "/nextflow_schema.json";

var downloadFile = (uri: string, dest: string) =>
  new Promise((resolve, reject) => {
    let file = fs.createWriteStream(dest);
    https.get(uri, (res) => {
      console.log("\n", "Downloading File");
      res
        .on("error", (error) => {
          reject(error);
        })
        .pipe(file)
        .on("finish", () => {
          file.close(resolve);
        });
    });
  });

downloadFile(schemapath, "nextflow_schema.json").then((file) => {
  console.log("File downloaded");
  var schema = JSON.parse(fs.readFileSync("nextflow_schema.json", "utf8"));

  // CREATE COMMANDLINETOOL //
  // Initialize a commandlinetool
  let nfCommandLineTool = new cwlTsAuto.CommandLineTool({
    cwlVersion: cwlTsAuto.CWLVersion.V1_2,
    class_: cwlTsAuto.CommandLineTool_class.COMMANDLINETOOL,
    requirements: [],
    hints: [],
    baseCommand: [],
    inputs: [],
    outputs: [],
  });
  // Add baseCommand
  nfCommandLineTool.baseCommand = ["nextflow", "run", pipeline];
  // Add optional Inputs
  getParams(schema, nfCommandLineTool);
  // Add mandatory Inputs (necessary in all nf-pipelines)
  let nfInput_r = createInput("release", "string?", "-r", Number(version));
  nfCommandLineTool.inputs.push(nfInput_r);
  let nfInput_profile = createInput("profile", "string?", "-profile", "singularity");
  nfCommandLineTool.inputs.push(nfInput_profile);
  // Add Output
  let nfOutput_out = new cwlTsAuto.CommandOutputParameter({
    type: cwlTsAuto.CWLType.DIRECTORY,
    id: "out_folder",
    outputBinding: new cwlTsAuto.CommandOutputBinding({
      glob: "$(inputs.outdir)", 
      //glob: '$(runtime.outdir)/$(inputs.outdir)'
    }),
  });
  nfCommandLineTool.outputs.push(nfOutput_out);

  // CREATE THE .CWL FILE //
  fs.writeFileSync(
    `./` + outname + `.cwl`,
    JSON.stringify(nfCommandLineTool.save())
  );
  console.log("The " + outname + ".cwl file has been created successfully");
});


/* ************************************* */
/////////////// FUNCTIONS ////////////////
/* ************************************* */
type CWLInputType =
  | string
  | cwlTsAuto.CommandInputRecordSchema
  | cwlTsAuto.CommandInputEnumSchema
  | cwlTsAuto.CommandInputArraySchema;

function createBinding(prefix: string): cwlTsAuto.CommandLineBinding {
  return new cwlTsAuto.CommandLineBinding({
    prefix: prefix,
  });
}

function createInput(
  name: string,
  type: CWLInputType | CWLInputType[],
  prefix: string,
  inputDefault: any
): cwlTsAuto.CommandInputParameter {
  let binding = createBinding(prefix);
  //return new cwlTsAuto.CommandInputParameter({
  var newInput = new cwlTsAuto.CommandInputParameter({
    id: name,
    type: type,
    inputBinding: binding,
  });
  newInput.default_ = inputDefault;
  return newInput;
}

function mapNfTypeToType(nfType: string): string {
  // ToDo: check if nfType is in schema
  switch (nfType) {
    case "file_path": {
      return "File";
    }
    case "directory-path": {
      return "Directory";
    }
    case "path": {
      //ToDo: if input has ending .gz return File, otherwise return Directory
      return "File";
    }
    case "number": {
      //ToDo: Check if it can be int or float?
      return "int";
    }
    case "integer": {
      return "int";
    }
    case "string": {
      return "string";
    }
    case "boolean": {
      return "boolean";
    }
    default: {
      throw Error("Input type not supported: " + nfType);
    }
  }
}

function getParams(schema: any, cmdltool: any) {
  //let i = 3;
  for (var item in schema.definitions) {
    var category = schema.definitions[item];
    for (var prop in category.properties) {
      var property = category.properties;
      // get input parameter's name and --prefix
      var name = prop;
      var prefix = "--" + prop;
      // get input parameter's type
      var type = mapNfTypeToType(property[prop].type) + "?";
      // get input parameter's format, if defined
      if (property[prop].format) {
        var format = property[prop].format;
      }
      // get input parameter's default, if defined
      if (property[prop].default) {
        var defaultval = property[prop].default;
        //check if defaultval contains a relative path like ${projectDir} or ${baseDir}
        if (defaultval.toString().includes("${projectDir}")) {
          let re = /\${projectDir}/gi;
          defaultval = defaultval
            .toString()
            .replace(re, gitpath + pipeline + "/" + version);
        } else if (defaultval.toString().includes("${baseDir}")) {
          let re = /\${baseDir}/gi;
          defaultval = defaultval
            .toString()
            .replace(re, gitpath + pipeline + "/" + version);
        }
      }
      // create Input object
      let nfInput = createInput(name, type, prefix, defaultval);
      // add Input to the commandline tool
      cmdltool.inputs.push(nfInput);
      //reset format and defaultval for next loop
      format = null;
      defaultval = null;
      //i = i+1;
    }
  }
}

