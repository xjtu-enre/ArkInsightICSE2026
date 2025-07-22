const fs = require('fs');
const path = require('path');
const config_list=['ef_rcp','harmony-dialog','pjtabbar','pull_to_refresh','xt_hud','zrouter'];
function convet_from_enre_to_benchmark(jsonData){

  const idToFullname = new Map();
  jsonData.entities.forEach(entity => {
    const full_split=entity.fullname.split('.');
    if(!(/^<Pkg @.*$/.test(full_split[0]))){
      full_split[0]=full_split[0].replace('C:\\Users\\25107\\Desktop\\ArkTS_docs\\benchmark_repo\\','');
      for(let i=1;i<full_split.length;i++){
        if (/^<Block .*:.*>$/.test(full_split[i])) {
          full_split.splice(i, 1);
          i-=1;
        }
        else if (/^<Anon ArrowFunction>@.*:.*$/.test(full_split[i])) {
          full_split[i] = full_split[i].replace('<Anon ArrowFunction>','<Arrow Function>');
        }
      }
      entity.fullname=full_split.join('.');
    }
    else{
      if(/^<Pkg @.*$/.test(full_split[0])&&full_split.length>1){
        const filename=full_split[1].split('\\');
        //TODO:
        filename[0]=`<File ${config_list[4]}\\src`;
        full_split[1]=filename.join('\\');
        for(let i=2;i<full_split.length;i++){
          if (/^<Block .*:.*>$/.test(full_split[i])) {
            full_split.splice(i, 1);
            i-=1;
          }
          else if (/^<Anon ArrowFunction>@.*:.*$/.test(full_split[i])) {
            full_split[i] = full_split[i].replace('<Anon ArrowFunction>','<Arrow Function>');
          }
        }
        entity.fullname=full_split.slice(1).join('.');
      }
      else if(full_split[0]==='SDK'){
        entity.fullname=full_split[full_split.length-1];
      }
    }
    idToFullname.set(entity.id, entity.fullname);
  });
  const idToEntity = new Map();
  jsonData.entities.forEach(entity => {
    idToEntity.set(entity.id, entity);
  });
  const callRelations = jsonData.relations
    .filter(rel => rel.type === 'call')
    .filter(rel => {
      if (rel.to === undefined) return false;
      const to_en=idToEntity.get(rel.to);
      return ['method', 'function','class','struct'].includes(to_en.type);
    })
    .map(rel => {
      const fromFullname = idToFullname.get(rel.from);
      const toFullname = idToFullname.get(rel.to);

      const result = {
        from:rel.from,
        to:rel.to,
        location:rel.location,
        sdkMethod:rel.isSdk,
      };
      result.from = fromFullname || `[UNKNOWN ID:${rel.from}]`;
      result.to = toFullname || `[UNKNOWN ID:${rel.to}]`;
      return result;
    });

  return callRelations;
}
function conver_string(from){
  const full_split=from.split('.');
  for(let i=0;i<full_split.length;i++){
    if (full_split[i].search('Arrow Function')!==-1) {
      full_split[i] = '<ArrowFunction>';
      return full_split[0]+'.'+full_split[i];
    }
  }
  return full_split.join('.');
}
function compareJSONFiles(file1Path, file2Path, outputPath) {

  let json1 = JSON.parse(fs.readFileSync(file1Path, 'utf8'));
  const json2 = JSON.parse(fs.readFileSync(file2Path, 'utf8'));

  //TODO:

  json1=convet_from_enre_to_benchmark(json1);


  const createMap = (arr) => {
    const map = new Map();
    arr.forEach(item => {
      ////TODO:
      item.from=conver_string(item.from);
      item.to=conver_string(item.to);
      item.location={
        line:100,
        column:50
      };

      const key = `${item.from}|${item.to}|${item.location.line}|${item.location.column}`;
      map.set(key, item);
    });
    return map;
  };

  ////TODO:

  //const map1 = createMap(json1.filter(item => item.sdkMethod===false));
  const map2 = createMap(json2.filter(item => item.sdkMethod===false));
  const map1 = createMap(json1);
  // const map2 = createMap(json2);

  const results = {
    same: [],             
    location_fault: [],   
    to_fault: [],         
    from_fault: [],       
    location_same: [],    
    file1_only: [],       
    file2_only: []        
  };

  for (const [key, item1] of map1) {
    if (map2.has(key)) {
      results.same.push({
        ...item1,
        source: 'both'
      });
      map2.delete(key);
      map1.delete(key);
    }
  }

  const remainingMap1 = new Map(map1);
  const remainingMap2 = new Map(map2);

  for (const [key1, item1] of remainingMap1) {
    for (const [key2, item2] of remainingMap2) {
      if (item1.from === item2.from &&
        item1.to === item2.to &&
        (item1.location.line !== item2.location.line ||
          item1.location.column !== item2.location.column)) {

        results.location_fault.push({
          file1: item1,
          file2: item2
        });
        map1.delete(key1);
        map2.delete(key2);
      }
    }
  }

  for (const [key1, item1] of map1) {
    for (const [key2, item2] of map2) {
      if (item1.from === item2.from &&
        item1.location.line === item2.location.line &&
        item1.location.column === item2.location.column &&
        item1.to !== item2.to) {

        results.to_fault.push({
          file1: item1,
          file2: item2
        });
        map1.delete(key1);
        map2.delete(key2);
      }
    }
  }

  for (const [key1, item1] of map1) {
    for (const [key2, item2] of map2) {
      if (item1.to === item2.to &&
        item1.location.line === item2.location.line &&
        item1.location.column === item2.location.column &&
        item1.from !== item2.from) {

        results.from_fault.push({
          file1: item1,
          file2: item2
        });
        map1.delete(key1);
        map2.delete(key2);
      }
    }
  }

  // for (const [key1, item1] of map1) {
  //   for (const [key2, item2] of map2) {
  //     if (item1.to !== item2.to &&
  //       item1.location.line === item2.location.line &&
  //       item1.location.column === item2.location.column &&
  //       item1.from !== item2.from) {
  //
  //       results.location_same.push({
  //         file1: item1,
  //         file2: item2
  //       });
  //       map1.delete(key1);
  //       map2.delete(key2);
  //     }
  //   }
  // }

  map1.forEach(item => results.file1_only.push(item));
  map2.forEach(item => results.file2_only.push(item));

  fs.writeFileSync(outputPath, JSON.stringify(results, null, 2));
  console.log(`Save the result: ${outputPath}`);
}
const args = process.argv.slice(2);
if (args.length !== 3) {
  console.log('Usage is: node compare.js <file1.json> <file2.json> <output.json>');
  process.exit(1);
}
compareJSONFiles(args[0],args[1],args[2]);