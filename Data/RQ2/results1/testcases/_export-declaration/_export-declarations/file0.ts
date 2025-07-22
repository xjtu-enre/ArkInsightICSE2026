export const a = 1, b = 2, c = 3;

export function foo() {
    /* Empty */
}

export class Foo {
    /* Empty */
}

export enum Bar {
    /* Empty */
}

export interface Baz {
    /* Empty */
}

export type TYPE = number;

export namespace NS {
    /* Empty */
}

// In transpiled code, only variable A is exported.
export namespace A.B.C {
    /* Empty */
}