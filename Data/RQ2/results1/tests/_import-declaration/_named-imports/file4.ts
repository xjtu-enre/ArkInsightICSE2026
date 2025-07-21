import defaultExport, {
    // Named imports can still import the default export
    default as IFoo,
    OptionalNumber,
} from './file0';

let foo: defaultExport;
let bar: IFoo;