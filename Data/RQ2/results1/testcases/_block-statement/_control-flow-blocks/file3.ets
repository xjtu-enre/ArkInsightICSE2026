// The switch statement does not create a block entity
switch (foo) {
    case 0:
        /* Empty */
        break;
        
    // A case statement can also be a block, where block-scope variables can be declared
    case 1: {
        /* Empty */
    }
}
/**
 * This is not a unqiue feature, the BlockStatement has the same role as other valid
 * expressions in the SwitchCase, that is, multiple BlockStatements, BlockStatement
 * before/after other valid expressions are allowed.
 */