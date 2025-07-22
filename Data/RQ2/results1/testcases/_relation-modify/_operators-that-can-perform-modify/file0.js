let a = 1;

a++;
++a;
a--;
--a;
a *= 1;
a /= 1;
a %= 1;
a += 1;
a -= 1;
a <<= 1;        // Left shift assignment
a >>= 1;        // Right shift assignment
a >>>= 1;       // Unsigned right shift assignment 
a &= 1;
a ^= 1;
a |= 1;
a **= 1;

// Short-circuit logical evaluation and assignments
a &&= 'aaa'     // Equvalent to a && (a = 'aaa')
a ||= 'aaa'     // Equvalent to a || (a = 'aaa')
a ??= 'aaa'     // Equvalent to a ?? (a = 'aaa')