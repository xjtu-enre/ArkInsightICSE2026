## Entity: Property

A `Property Entity` is a public *variable* or *function* defined inside an Entity but not class

### Supported Patterns
```yaml
name: Property Declaration
```

#### Syntax: property Declaration

```text
InterfaceDeclaration :
    `interface` BindingIdentifier [TypeParameters] [InterfaceExtendsClause] ObjectType

InterfaceExtendsClause :
    `extends` ClassOrInterfaceTypeList

ClassOrInterfaceTypeList :
    ClassOrInterfaceType
    ClassOrInterfaceTypeList `,` ClassOrInterfaceType

ClassOrInterfaceType :
    TypeReference
```
```yaml
name: property declaration
```

##### Examples

###### Property of a interface

```ets
interface A {
    a: string
}
```

```yaml
name: Simple property declaration
entity:
    type: property
    extra: false
    items:
        -   name: A.a
            loc: 2:5
```

### Properties

| Name | Description | Type | Default |
|------|-------------|:----:|:-------:|
