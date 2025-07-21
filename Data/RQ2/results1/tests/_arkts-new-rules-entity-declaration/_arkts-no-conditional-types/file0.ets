// 在类型别名中提供显式约束
type X1<T extends number> = T

// 用Object重写，这种情况下，类型控制较少，需要更多的类型检查以确保安全
type X2<T> = Object

// Item必须作为泛型参数使用，并能正确实例化
type YI<Item, T extends Array<Item>> = Item