abstract class Foo {
  abstract field0: number;
  public abstract field1: number;
  protected abstract field2: number;

  // Invalid
  // TSError: 'private' modifier cannot be used with 'abstract' modifier.
  private abstract field3: number;
  // TSError: 'abstract' modifier cannot be used with a private identifier.
  abstract #field4: number;
  // TSError: 'static' modifier cannot be used with 'abstract' modifier.
  static abstract field5: number;
}