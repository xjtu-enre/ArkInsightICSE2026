## Relation: Extend

An `Bind Relation` establishes a link between `Field Entity`s to setups a bidirectional synchronization on their value.

### Supported Patterns

```yaml
name: Bind declaration
```

#### Syntax: Basic

```text
FieldBind :
    Field1 bindExpression Field2

bindExpression :
    ArkTSDoubleExclamationExpression
    ArkTSTwoWayBindingExpression
```

Only ArkTS support this.

##### Examples

###### basic bind

```ets
@Entry
@ComponentV2
struct Index {
  @Local value: number = 0;

  build() {
     Star({ value: this.value!! })
  }
}

@ComponentV2
struct Star {
  @Param value: number = 0;
  @Event $value: (val: number) => void = (val: number) => {};

  build() {
     Column()
  }
}
```

```yaml
name: basic bind
relation:
    type: bind
    implicit: true
    items:
        - from: field:'Star.value'
          to: field:'Index.value'
          loc: 7:13:1
```


### Properties

| Name | Description | Type | Default |
|------|-------------|:----:|:-------:|
