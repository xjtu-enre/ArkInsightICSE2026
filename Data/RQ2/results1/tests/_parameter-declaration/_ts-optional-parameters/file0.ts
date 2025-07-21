function foo(
    param0?: number,
    {param1} = {param1: 'content'},
    param2?: 'default param2',
) {
    /* Empty */
}

// Usage
foo();
foo(0);
foo(0, {param1: 'another content'});
/**
 * Parameter with type as `StringLiteral` can be assigned
 * only with that string literal.
 */
foo(0, {param1: 'another content'}, 'default param2');

// Invalid
// foo(0, {param1: 'another content'}, 'another param2');
// TSError: Argument of type '"another param2"' is not assignable to parameter of type '"default param2"'.