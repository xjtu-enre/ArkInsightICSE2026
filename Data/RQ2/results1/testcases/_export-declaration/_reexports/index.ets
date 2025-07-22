export {T, I} from './file0';

export {default as C} from './file1';

/**
 * `default` as IdentifierName has restricted meaning - the default export,
 * a not-renamed reexport of `default` will make it still a default export.
 */
export {default} from './file2';