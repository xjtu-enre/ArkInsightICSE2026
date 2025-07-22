class Foo {
    a;
    b = 1;

    /**
     * Any unicode character is supported,
     * unless the literal fails the cast towards identifier,
     * this will be the same as an identifier.
     */
    'c';
    '✅';

    /**
     * Numeric literal will firstly be converted to standard
     * number in base 10, then be cast to string as a key.
     */
    3;
    1_000_000;
    1e-3;

    /**
     * Computed key will NOT be extracted by ArkInsight.
     */
    [`!computed${d}`];
}

/**
 * After instantiating, an instance will contain following fields:
 *
 * foo {
 *   '3': undefined,
 *   '1000000': undefined,
 *   a: undefined,
 *   b: 1,
 *   c: undefined,
 *   '✅': undefined,
 *   '0.001': undefined,
 *   '!computedKey': undefined // Assume d is 'Key'
 * }
 */