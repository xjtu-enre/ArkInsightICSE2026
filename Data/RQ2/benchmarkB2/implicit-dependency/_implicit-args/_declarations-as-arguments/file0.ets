function foo(a:()=>void):void {
    a()
}

foo(() => {
    /* Empty */
})