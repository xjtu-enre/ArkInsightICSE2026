class Foo {
    a = 0;
}

class Bar extends Foo {
    get a() {
        return 1;
    }
}

new Bar().a // 0