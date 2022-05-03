import * as cwlTsAuto from 'cwl-ts-auto'
import * as fs from 'fs'

//import { prefixUrl } from 'cwl-ts-auto/dist/util/Saveable';
//import * as path from 'path'
//import * as yaml from 'js-yaml'

//export const paramsList = ['type', 'format', 'default']

const path = "https://raw.githubusercontent.com/"
//ToDo: collect these parameters as console input
const pipeline = "nf-core/rnaseq"
const tag = "master"
const version = 3.6

//const schemapath = path+pipeline+'/'+tag+'/nextflow_schema.json'
import * as schema from './nextflow_schema.json';

export interface nfInputType {
    name: string    //id and prefix
    type: string    //type, may depend on format, if defined
    default: any    //default value, if given
  }

type CWLInputType =
  | string 
  | cwlTsAuto.CommandInputRecordSchema 
  | cwlTsAuto.CommandInputEnumSchema 
  | cwlTsAuto.CommandInputArraySchema 

function createBinding (prefix: string): cwlTsAuto.CommandLineBinding {
    return new cwlTsAuto.CommandLineBinding({
            prefix: prefix
    })
}

export const formatTypes = ['file-path', 'directory-path', 'path']
function mapNfTypeToType (nfType: string): string {
    // ToDo: check if nfType is in schema
    switch (nfType) {
      case 'file_path': {
        return 'File'
      }
      case 'directory-path': {
        return 'Directory'
      }
      case 'path': {
          //ToDo: if input has ending .gz return File, otherwise return Directory
        return 'File'
      }
      default: {
        throw Error('Input type not supported: ' + nfType)
      }
    }
  }

export function createMinimalInput (name: string, type: CWLInputType | CWLInputType[], prefix: string, inputDefault: any): cwlTsAuto.CommandInputParameter {
    let binding = createBinding(prefix)
    //return new cwlTsAuto.CommandInputParameter({
    var newInput = new cwlTsAuto.CommandInputParameter({
        id: name,
        type: type,
        inputBinding: binding,
    })
    newInput.default_ = inputDefault
    return newInput
}

let nfCommandLineTool =
new cwlTsAuto.CommandLineTool({
    cwlVersion: cwlTsAuto.CWLVersion.V1_2,
    class_: cwlTsAuto.CommandLineTool_class.COMMANDLINETOOL,
    requirements: [],
    hints: [],
    baseCommand: [],
    inputs: [],
    outputs: []
})

nfCommandLineTool.baseCommand = ['nextflow', 'run', pipeline]

export function getParams (schema: any, cmdltool: any) {
  //let i = 3;
  for (var item in schema.definitions) {
      var category = schema.definitions[item];
      for (var prop in category.properties) {
          var property = category.properties;
          // get input parameter's name and --prefix
          var name = prop;
          var prefix = "--"+prop
          // get input parameter's type
          var type = property[prop].type + "?";
          if (type=='integer?'){
            type='int?'
          }
          // get input parameter's format, if defined
          if(property[prop].format) {
              var format = property[prop].format;
          }
          // get input parameter's default, if defined
          if(property[prop].default) {
              var defaultval = property[prop].default;
              //check if defaultval contains a relative path like ${projectDir} or ${baseDir}
              if (defaultval.toString().includes("${projectDir}")) {
                let re = /\${projectDir}/gi;
                defaultval = defaultval.toString().replace(re, path + pipeline +'/' + tag);
            } else if (defaultval.toString().includes("${baseDir}")){
                let re = /\${baseDir}/gi;
                defaultval = defaultval.toString().replace(re, path + pipeline +'/' + tag);   
            }

          }
          let nfInput = createMinimalInput(name, type, prefix, defaultval)
          cmdltool.inputs.push(nfInput)
          //reset format and defaultval for next loop
          format=null
          defaultval=null
          //i = i+1;      
      }
  }
}
getParams(schema, nfCommandLineTool)

let nfInput_r = createMinimalInput("release", "float?", "-r", version)
nfCommandLineTool.inputs.push(nfInput_r)
let nfInput_profile = createMinimalInput("profile", "string?", "-profile", "singularity")
nfCommandLineTool.inputs.push(nfInput_profile)

//let nfOutput_out = createMinimalOutput("out_folder", "Directory")
let nfOutput_out = new cwlTsAuto.CommandOutputParameter({
  type: cwlTsAuto.CWLType.DIRECTORY,
  id: 'out_folder',
  //outputBinding: new cwlTsAuto.CommandOutputBinding({ glob: '$(runtime.outdir)/$(inputs.outdir)' })
  outputBinding: new cwlTsAuto.CommandOutputBinding({ glob: 'inputs.outdir' })
})
nfCommandLineTool.outputs.push(nfOutput_out)

//console.log("Output from nfCommandLineTool:")
//console.log(JSON.stringify(nfCommandLineTool.save()))

//ToDo include output name as user-option
fs.writeFileSync(`./rnaseq.cwl`, JSON.stringify(nfCommandLineTool.save()))


/* ************************************* */
/* CODE SNIPPETS */
/* ************************************* */

//console.log(`input properties: ${schema.definitions.input_output_options.properties.input.type}`);
//console.log(`input properties: ${schema.definitions.input_output_options.properties.input.help_text}`);

/*type InputSchema =
  |string
  | cwlTsAuto.CommandInputArraySchema
  | cwlTsAuto.CommandInputRecordSchema
  | cwlTsAuto.CommandInputEnumSchema

  type CWLOutputType =
  | string 
  | cwlTsAuto.CommandOutputRecordSchema 
  | cwlTsAuto.CommandOutputEnumSchema 
  | cwlTsAuto.CommandOutputArraySchema

type OutputSchema =
  | string
  | cwlTsAuto.CommandOutputArraySchema
  | cwlTsAuto.CommandOutputRecordSchema
  | cwlTsAuto.CommandOutputEnumSchema
*/

/*export function createMinimalOutput (name: string, type: CWLOutputType | CWLOutputType[]): cwlTsAuto.CommandOutputParameter {
    //return new cwlTsAuto.CommandOutputParameter({
    var newOutput = new cwlTsAuto.CommandOutputParameter({
        id: name,
        type: type,
        //outputBinding: binding
    })
    return newOutput
}*/

/*export function extractGaInputsFromGaFile (gaFile: any): GAInputType[] {
    const gaInputs: GAInputType[] = []
  
    for (const input in gaFile.steps) {
      const step = gaFile.steps[input]
      let stepType: string = step.type
  
      if (stepType === 'parameter_input') {
        stepType = JSON.parse(step.tool_state).parameter_type
      }
  
      if (inputTypes.includes(stepType)) {
        if (step.label == null) {
          throw Error('Unnamed input detected, aborting. Please speficy a label for all inputs!')
        }
        gaInputs.push({ name: step.label, type: stepType })
      }
    }
    return gaInputs
  }*/
/*
export function getParameter (schema: any, cmdltool: any) {
    for (var item in schema.definitions) {
        console.log("INPUT PARAMETERS FOR: " + item);
        var category = schema.definitions[item];
        for (var prop in category.properties) {
            var property = category.properties;
            // get input parameter's name / --prefix
            console.log(prop);
            var name = prop;
            var prefix = "--"+prop
            // get input parameter's type
            console.log("\t" + property[prop].type);
            var type = property[prop].type + "?";
            // get input parameter's format, if defined
            if(property[prop].format) {
                console.log("\t" + property[prop].format);
                var format = property[prop].format;
            }
            // get input parameter's default, if defined
            if(property[prop].default) {
                console.log("\t" + property[prop].default);
                var defaultval = property[prop].default
            }
            let nfInput = createMinimalInput(name, type, 1, prefix, defaultval)
            cmdltool.inputs.push(nfInput)      
        }
    }
}*/
//getParams(schema, nfCommandLineTool)
// Access and print input parameters from nextflow_schema.json
 /*for (var item in schema.definitions) {
    console.log("INPUT PARAMETERS FOR: " + item);
    var category = schema.definitions[item];
    for (var prop in category.properties) {
        var property = category.properties;
        // get input parameter's name / --prefix
        console.log(prop);
        // get input parameter's type
        console.log("\t" + property[prop].type);
        // get input parameter's format, if defined
        if(property[prop].format) {
            console.log("\t" + property[prop].format);
        }       
    }
}

// Get default value from nextflow.config
// reads config file
let config = fs.readFileSync('nextflow.config','utf8');
// splits config file in lines
for (const line of config.split(/[\r\n]+/)){
    //searches line for keyword (here "input")
    if(line.includes("input")) {
        // splits line with "input = null" at "="
        var l = line.split(/[\r=]+ /);
        console.log(line);
        //gives out the value
        console.log(l[1]);
    }   
  }
   */

  /*let testbind = createBinding(1,"testprefix")
console.log(testbind.prefix+'?', testbind.position)*/

