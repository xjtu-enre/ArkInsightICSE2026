class Rectangle {
  /**
   * In TypeScript, fields must be explicitly declared
   * before referenced using `this.*`.
   * If this is forced to be ignored, then it will fallback to
   * JS implicit field declaration that works in runtime.
   */
  area: number;
  private height: number;
  private width: number;
  constructor(height: number, width: number) {
    /**
     * Below two expressions are not necessary.
     * TypeScript will automatically insert these at compile time.
     */
    // this.height = height;
    // this.width = width;
    this.area = height * width;
  }
}