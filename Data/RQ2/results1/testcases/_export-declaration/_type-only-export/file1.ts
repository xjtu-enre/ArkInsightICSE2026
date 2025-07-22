import type {Foo} from './file0';

// Usage
let obj: Foo;

// Invalid
class C extends Foo {
    // TSError: 'Foo' cannot be used as a value because it was imported using 'import type'.
}