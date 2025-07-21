## Entity: Module

A `Module Entity` is a ArkTS module, which usually contains a `module.json5` file to indicate this, and its name can
be used as an HAP package for use.

> Please note the difference between a `ECMAScript Module` and a `ArkTS Module`. Both them can be imported, but
> a `ECMAScript Module` may only refer to a single TS/JS source file (which is covered in `File Entity`); and a `ArkTS Module` is
> more complicated since it can contain multiple directories and files, properties of a `ArkTS Module` is defined in
> corresponding `module.json5` file。(`ArkTS Module` **Can NOT** be nested.)

### Supported Patterns

```yaml
name: Module declaration
freeForm: true
```

#### Semantic: Single Module

Typically, every `ArkTS` project contains at least one `module.json5` file. With that file presents, a `ArkTS`
module is then defined. The directory structure can be described as the following graph.

```text
ModuleName(Usually 'Entry/Feature')
|--src/main
    |-- resources/
    |-- ets/
    `-- module.json5
```

Properties in `module.json5` define much useful information, such as name, version, type(determines whether the module
systems is Entry(HAP) or Feature(HSP)), srcEntry, etc.

##### How `module.json5` affects the results

Some properties may have impact on the static analysis process, which are listed below.

###### `name` field

`name` specifies the name of the module, which may be used in import specifiers.


###### `type` field

`type` specifies the module format that `ArkTS` uses for all Module,including `entry`/`feature`/`har`/`shared`
###### `files` field


###### `srcEntry` field

> Default: `index.ets` in the module's `src/ets` directory 's root folder

`srcEntry` specifies the entry point of the module, that is the UIAbility/ExtensionAbility. 




### Properties

| Name | Description | Type | Default |
|------|-------------|:----:|:-------:|
