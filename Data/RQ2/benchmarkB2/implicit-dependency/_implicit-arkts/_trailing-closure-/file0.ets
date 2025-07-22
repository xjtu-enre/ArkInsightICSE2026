@Component
struct A {
    build() {
        Row() {
            /* Empty */
        }
    } 
}
@Component
struct B {
  build() {
    A(){
        /* Empty */
    }
  }
}