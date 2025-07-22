import { SceneConfig, Sdk } from '../../src/Config';
import { Scene } from '../../src/Scene';
import { CallGraph } from '../../src/callgraph/model/CallGraph';
import { CallGraphBuilder } from '../../src/callgraph/model/builder/CallGraphBuilder';
import { Pag } from '../../src/callgraph/pointerAnalysis/Pag'
import { PointerAnalysis } from '../../src/callgraph/pointerAnalysis/PointerAnalysis'
import { PtaAnalysisScale, PointerAnalysisConfig } from '../../src/callgraph/pointerAnalysis/PointerAnalysisConfig';
import { PtsCollectionType } from '../../src/callgraph/pointerAnalysis/PtsDS';
import { Local } from '../../src/core/base/Local';
import { ArkThisRef } from '../../src/core/base/Ref';
import { ArkAssignStmt } from '../../src/core/base/Stmt';
import { ArkMethod } from '../../src/core/model/ArkMethod';
import Logger, { LOG_LEVEL } from '../../src/utils/logger';
import * as fs from 'fs';
const config_list=['ef_rcp','harmony-dialog','pjtabbar','pull_to_refresh','xt_hud','zrouter'];

Logger.configure('./out/ArkAnalyzer.log', LOG_LEVEL.TRACE)
let config: SceneConfig = new SceneConfig()
let sdk: Sdk = {
    name: 'ohos',
    path: '',
    moduleName: ''
};
sdk;

function printStat(pta: PointerAnalysis): void {
    console.log(pta.getStat());
}

function dumpIR(scene: Scene) {
    scene.getMethods().forEach(fun => {
        console.log('\n---\n' + fun.getSignature().toString())
        if (!fun.getCfg())
            return;

        console.log('{');
        let i = 0;
        fun.getCfg()?.getBlocks().forEach(bb => {

            console.log(`  bb${i++}:`)
            bb.getStmts().forEach(stmt => {
                console.log('    ' + stmt.toString());
            })
        })
        console.log('}')
    });
}

function printTypeDiff(pta: PointerAnalysis) {
    let dm = pta.getTypeDiffMap();
    for (let [v, types] of dm) {
        console.log('=======')
        if (v instanceof Local) {
            if (v.getName() == 'this') {
                continue;
            }

            let s = v.getDeclaringStmt()
            if (s instanceof ArkAssignStmt && s.getLeftOp() instanceof Local && (s.getLeftOp() as Local).getName() === 'this'
                && s.getRightOp() instanceof ArkThisRef) {
                continue;
            }

            if (s) {
                console.log('Method: ' + s?.getCfg()?.getDeclaringMethod().getSignature().toString());
                console.log('Declare: ' + s);
            }
        }

        console.log(v)
        console.log('----\n' + v.getType().toString());
        for (let t of types) {
            console.log('  ' + t.toString());
        }

    }
}

function runDir(output: string) {

    config.buildFromProjectDir("tests\\resources\\pta\\my_cases");
    // config.buildFromProjectDir("C:\\Users\\25107\\Desktop\\ArkTS_docs\\benchmark_repo\\"+config_list[5]+"//src");
    config.getSdksObj().push(sdk);

    let projectScene: Scene = new Scene();
    projectScene.buildSceneFromProjectDir(config);
    projectScene.inferTypes();

    let cg = new CallGraph(projectScene);
    let cgBuilder = new CallGraphBuilder(cg, projectScene);
    cgBuilder.buildDirectCallGraphForScene();

    let pag = new Pag();
    let debugfunc = cg.getEntries()//.filter(funcID => cg.getArkMethodByFuncID(funcID)?.getName() === 'main');

    let ptaConfig = PointerAnalysisConfig.create(2, output, true, true, true, PtaAnalysisScale.WholeProgram, PtsCollectionType.BitVector)
    let pta = new PointerAnalysis(pag, cg, projectScene, ptaConfig)
    pta.setEntries(debugfunc);
    pta.start();

    cg.dump(output + '/implict-subcg.dot', debugfunc[0])

    cg.dumpToJson(output + '/output.json');
    convet_json('out\\output.json',`out\\Ark_${config_list[5]}.json`);
    cgBuilder.setEntries()

    dumpIR(projectScene)
    printTypeDiff(pta);

    printStat(pta);
}

runDir('./out');
        
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