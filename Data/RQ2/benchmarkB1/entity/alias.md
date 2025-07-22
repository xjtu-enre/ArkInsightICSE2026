## Entity: Type Alias

A `Alias Entity` is a convenient alias usually for a import entity.

### Supported Patterns

```yaml
name: Alias declaration
```

#### Syntax: Alias Declaration

```text
Declaration :
    AliasDeclaration
...

##### Examples

###### Simple alias declaration

```ets
import foo as t from './test1.ets'
```
```ets
export function foo(){
    
}
```

```yaml
name: Simple alias declaration
entity:
    type: alias
    extra: false
    items:
        -   name: t
            loc: 1:15
```

### Properties

| Name | Description | Type | Default |
|------|-------------|:----:|:-------:|
