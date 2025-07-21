# 2026ICSE-ArkInsight
This repository illustrates the tools, data, and scripts of our ICSE 2026 under-reviewing work, Demystifying ArkTS Dependencies for OpenHarmony: A Static Analysis with Custom Parser.

We make our tool's benchmarks and all experimental results publicly available. Due to the file size limit of GitHub, we upload the processed data to this repository. 

## Directory Structure

The whole directory goes like the following:
```
├─README.md 
├─Scripts
├─Data
│  ├─RQ1 
│  │  ├─micro-benchmark A
|  |  |  └─code
│  │  └─results      
│  │     ├─ArkAnalyzer
│  │     ├─ArkInsight
│  │     └─Compared_result
│  ├─RQ2
│  │  ├─micro-benchmark B1
|  |  |  ├─entity
|  |  |  ├─dependency
|  |  |  └─README
│  │  └─results1      
│  │  |  ├─tests
│  │  |  └─ArkInsight
│  │  ├─micro-benchmark B2
│  │  │  └─implicit-dependency 
│  │  └─results2
│  │     ├─ArkAnalyzer
│  │     └─ArkInsight
│  ├─RQ3
│  │  ├─macro-benchmark C
│  │  │  ├─projects
│  │  │  └─ground-truth
│  │  └─results
│  │     ├─ArkAnalyzer
│  │     └─ArkInsight
│  └─RQ4
|     ├─macro-benchmark D
│     │  └─project_list.csv
│     └─results
│        ├─result_list.csv
│        └─result.png
|
└─Methods              

```

## Methods

This directory contains our executable program.

### Requirements

- Operating System : Windows
- Node.js 16~18.

### Usages

Append `-h` or `--help` without any other arguments to see list of options:

```text
Usage: node ArkInsight.mjs [options]

A static source code entity relationship extractor for ArkTS.

Options:
  -V, --version                         output the version number
  -i, --input <path>                    specify the path to a file or directory (default: ".")
  -o, --output <file path>/false        specify where to output the Analyze results
                                        use extension '.json' (default) or '.lsif' to specify format (default: "./output.json")
  -e, --exclude <name...>               specify file or directory name to be excluded from analysis
  -s, --sdk                             Include sdk class/method from local component file (default: false)
  -E, --exclude                         Exclude files with other extension, only analyze '.ets' files
  -v, --verbose                         enable to print more message while processing (default: false)
  -g, --callgraph <file path>/false     specify where to output the callgraph
                                        use extension '.json' (default) or '.lsif' to specify format
  -R, --RTA <file path>/false           specify where to output the RTA-callgraph
                                        use extension '.json' (default) or '.lsif' to specify format
  -P, --PTA <file path>/false           specify where to output the PTA-callgraph
                                        use extension '.json' (default) or '.lsif' to specify format
  -h, --help                            display help for command
```

### Examples

* Analyze files under a given directory (and output results in current working directory)

```shell
$ node ArkInsight.mjs -i path-to-directory
```

* Analyze a file and output results in JSON format in the given directory/file

```shell
$ node ArkInsight.mjs -i path-to-file.ets -o path-to-output-result.json
```

* Analyze a file and output results in JSON format in the given directory/file with only ArkTS file(.ets)

```shell
$ node ArkInsight.mjs -i path-to-directory -o path-to-output-result.json -E
```

## Data

This directory contains all the original data and final results of our four RQs.

### RQ1: What is the accuracy of ArkInsight in parsing ArkTS syntax, particularly deviations from TypeScript?
This folder contains two parts: the micro-benchmarkA used in RQ1 study and the output results of each static code dependency analyzers (*i.e., ArkInsight and ArkAnalyzer*) and the results when comparing them.

#### micro-benchmark A

##### code

This folder contains 69 ArkTS files and their parsing results expected.

- Each testcase consists of a set of ArkTS code snippets highlighting ArkTS's syntactic divergences from TypeScript, along with AST that is expected to be generated from the corresponding code.

#### results

This directory contains the data of collection results of micro-benchmarkA and the results of two static code dependency analyzers on tests for RQ1 study. Following diagrams shows the detail of each folder.

- **ArkAnalyzer** contains the parsing results of ArkAnalyzer. 
- **ArkInsight** contains the parsing results of ArkInsight.
- **Compared_results** contains the results of similarity calculation in RQ1.

### RQ2: What is the accuracy of ArkInsight in extracting code dependencies arising from ArkTS’s advanced features?
This folder contains four parts: the micro-benchmarkB1 and micro-benchmarkB2 used in RQ2 study and the output results of each static code dependency analyzers (*i.e., ArkInsight and ArkAnalyzer*).

#### micro-benchmark B1

##### entity

This folder contains 20 markdown files which record 19 kinds of entities. (*i.e., package, module, file, alias, block, class, enum, enum-member, field, method, function, interface, namespace, parameter, struct, variable, type-parameter, type-alias, property.*) Taking the class.md file as an example:

- Each file consists of a set of executable ArkTS code snippets along with entities that are expected to be extracted from the corresponding code.

  ```ets
  //// test0.ets
  class Foo{
      ...
  }

  ```

  ```yaml
  name: Simple class declaration
  entity:
    type: class
    extra: false
    items:
        -   name: Foo
            loc: 1:7
  ```

- Groundtruth entities are recorded in text format.
- Each entity is labeled with several properties (*i.e., name, type that depicts the entity kind, location where the entity is declared in the source code, etc.*)
##### dependency
This folder contains 12 markdown files which record 11 kinds of dependencies. (*i.e., import, export, use, call, bind, extend, modify, set, type, implement, override*) Taking the call.md file as an example:

- Each file consists of a set of executable ArkTS code snippets along with dependencies that are expected to be extracted from the corresponding code.

  ```ets
  //// test0.ets
  
  class Foo {
      field0: number;
  }

  let foo: Foo;

  class Bar {
      field0: Foo;
  }

  function baz(param0: Foo) {
      /* Empty */
  }
  ```

  ```yaml
  name: Class in typing context
  relation:
      type: type
      items:
          -   from: class:'Foo'
              to: variable:'foo'
              loc: file0:5:10
          -   from: class:'Foo'
              to: field:'Bar.field0'
              loc: file0:8:13
          -   from: class:'Foo'
              to: parameter:'baz.param0'
              loc: file0:11:22
  ```

- Groundtruth dependencies are recorded in text format.
	
- Each dependency is labeled with src denoting the depended entity, dest denoting the dependent entity, type denoting the dependency kind, and location denoting the dependency site where the reference dependency happens.

#### results1

This directory contains the data of collection results of micro-benchmark B1 and the results of two static code dependency analyzers on tests for RQ2 study. Following diagrams shows the detail of each folder.

- **tests** contains the collection results of micro-benchmark B1. In total, the benchmark **236** tests in total.
- **ArkInsight** contains the analyzing results of ArkInsight.

#### micro-benchmark B2

This folder contains the benchmark newly added by our ArkInsight. The benchmark covers **7** categories and **51** tests.

#### results2

This directory contains the results of two static code dependency analyzers (*i.e., ArkAnalyzer and ArkInsight*) we selected on the **51** tests of micro-benchmark B2.

- **ArkInsight** contains the analyzing results of ArkInsight.

##### ArkAnalyzer

This folder contains the results of ArkAnalyzer on the benchmark B2， with three algorithm results both shown in JSON format and their original DOT format.

- `implicit_n.json` - the analyzing results of ArkAnalyzer with algorithm n.
- `Arkcg_implicit_n.json` - the analyzing results of ArkAnalyzer with algorithm n, conver its original format to JSON format.

### RQ3: What is the accuracy of ArkInsight in analyzing real-world projects? 

This directory contains two parts: the macro-benchmark C and the results.

#### macro-benchmark C

This directory contains our manual constructed macro-benchmark C, containing function-level dependencies from 6 real-world project.

##### projects

This directory contains the 6 projects' source code that our manual constructed. We record their call dependencies in **src** directory and ignoring the call to sdk and built-in apis. 

##### ground-truth

This directory contains our manual constructed macro-benchmark C. Firstly, we identified the most popular third-party libraries in the OpenHarmony Third-Party Library Center, We then downloaded top 100 repositories and calculated their ArkTS code size. The stars' data is up to May 17, 2025. We randomly selected six projects each with 1k to 5k lines of ArkTS code. 
We manually inspected and recorded their function-level dependencies in JSON format, and excluded call dependencies related to the SDK and built-in functions. 
The First and fourth author of this paper finally implemented a double check after independent verification during benchmark documentation.

#### results

- **ArkAnalyzer** contains the analyzing results of ArkAnalyzer with three algorithm, and our analysis of its results.
- **ArkInsight** contains the analyzing results of ArkInsight.

### RQ4: What is the time and memory consumption of ArkInsight to analyze real-world projects?

This directory contains two parts: a list of open source projects we collected and reused from ArkANalyzer, and the time and memory consumption of two static code dependency analyzers we have evaluated. 

#### list

This directory contains a list (`project_list.csv`) of open source projects. We firstly reused the projects collected by the work of ArkAnalyzer, consisting of 371 real-world projects from the OpenHarmony community. We then extended this dataset to 471 to incorporate the latest third-party ArkTS libraries by adding 100 projects collected in RQ3. We finally selected 471 * 32.3%=152 projects as ArkAnalyzer failed to scan the remainder by reporting _TypeError_ and _RangeError_.

In the experiment, all project files are stored on the local computer. Due to GitHub's file size upload limitations, we are unable to upload all project source files. Please connect us for the large-scale raw data if required. 

#### results

This directory contains a list (`result_list.csv`) of the time and memory consumption of two static code dependency analyzers and one figures(`result.png`) which show the comparison results of two tools on benchmarkD.

Each column in this file is *Project,LOC,ArkInsight-time,ArkInsight-memory-Heap,ArkInsight-memory-RSS,ArkAnalyzer-time,ArkAnalyzer-memory-Heap,ArkAnalyzer-memory-RSS*. The unit of time consumption is milliseconds and the unit of memory consumption is MB.

## Scripts

We use the following scripts in our experiment. Each RQn directory (where n takes values from 1 and 4) in this folder contains the scripts and documentation used for Research Question RQn. 

### RQ1_Script

This directory contains one subdirectorie `compare_ast`, which includes the script files we used for comparison with the baseline tool for ASTs. The design of AST similarity calculation algorithm we used is in `design.md`

### RQ4_Script

This file is the script used for RQ4, mainly to draw the fig. 
