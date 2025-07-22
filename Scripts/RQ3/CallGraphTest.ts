import { SceneConfig, Scene,  CallGraph, CallGraphBuilder, MethodSignature } from '../../src';
import * as fs from 'fs';
let config: SceneConfig = new SceneConfig();
const config_list=['ef_rcp','harmony-dialog','pjtabbar','pull_to_refresh','xt_hud','zrouter'];
function runDir(): void {
    config.buildFromProjectDir("tests\\resources\\pta\\my_cases");
    // config.buildFromProjectDir("tests\\resources\\callgraph\\calltest");
    let projectScene: Scene = new Scene();
    projectScene.buildSceneFromProjectDir(config);
    projectScene.inferTypes();

    let entryPoints: MethodSignature[] = [];

    entryPoints.push(
        ...projectScene
            .getFiles()
            //.filter(arkFile => arkFile.getName() === 'main.ts')
            .flatMap(arkFile => arkFile.getClasses())
            //.filter(arkClass => arkClass.getName() === DEFAULT_ARK_CLASS_NAME)
            .flatMap(arkClass => arkClass.getMethods())
            //.filter(arkMethod => arkMethod.getName() === 'main')
            .map(arkMethod => arkMethod.getSignature())
    );

    let callGraph = new CallGraph(projectScene);
    let callGraphBuilder = new CallGraphBuilder(callGraph, projectScene);
    if (true) {
        callGraphBuilder.buildClassHierarchyCallGraph(entryPoints, false);
    } else {
        callGraphBuilder.buildRapidTypeCallGraph(entryPoints, false);
    }
    callGraph.dump('out/cg.dot');
    callGraph.dumpToJson('out/cg_out.json');
    convet_json('out/cg_out.json',`out\\Ark_${config_list[1]}-RTA.json`);
}

runDir();

function convet_json(inputPath:string,outputPath:string){
    fs.readFile(inputPath, 'utf-8', (err, data) => {
        if (err) {
            console.error('Failed to read:', err);
            return;
        }

        try {
            const inputJson = JSON.parse(data);
            const result: any[] = [];
            let conver=(a:string)=>{
                const ff=a.split(':');
                let fromstring = a.split(':')[0];
                fromstring = fromstring.replace('@', ''); 
                fromstring = fromstring.replace(/\//g, '\\'); 
                const full_split=ff.slice(1).join(':').replace(/[\(].*[\)]/g, '').replace(' ','').replace(/%dflt./g,'').split('.');
                if(fromstring==='%unk\\%unk'){
                    return `${full_split[0]}`;   
                }
                
                for(let i=0;i<full_split.length;i++){
                    full_split[i]=full_split[i].replace(/[\(].*[\)]/g, '');
                    full_split[i]=full_split[i].replace('[static]', '');
                    
                    if (/^%AM.*$/.test(full_split[i])) {
                        full_split[i] = full_split[i].replace('%AM','<Arrow Function>');
                    }
                }
                return `<File ${config_list[1]}\\${fromstring}>.${full_split.join('.')}`.replace('.%dflt','');
                
            }
 
            Object.keys(inputJson).forEach(fromKey => {
                const toValues = inputJson[fromKey];
                toValues.forEach((toValue: string) => {
                    const from_string=conver(fromKey);
                    const to_string=conver(toValue);
                    
                    
                    const isSdkMethod = toValue.split(':')[0]==='@%unk/%unk';

                    
                    const outputObj = {
                        "from": from_string,
                        "to": to_string,
                        "location": {
                            "line": 100,
                            "column": 100
                        },
                        "type": "call",
                        "sdkMethod": isSdkMethod
                    };

                    result.push(outputObj);
                });
            });

            fs.writeFile(outputPath, JSON.stringify(result, null, 2), (err) => {
                if (err) {
                    console.error('Failed to write:', err);
                } else {
                    console.log('Convert END', outputPath);
                }
            });
        } catch (err) {
            console.error('Failed to read JSON:', err);
        }
    });
}