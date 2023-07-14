# Felt operations

A field element - felt, is a native type in Cairo. Learn more about it in the [Cairo book](https://cairo-book.github.io/ch02-02-data-types.html#felt-type) to learn more about it

Cairo1 has native integer types which support more operators then felts, like %, /
Take a look [here](https://cairo-book.github.io/ch02-02-data-types.html#integer-types) for more details

# Variables

In Cairo, variables are immutable by default.
When a variable is immutable, once a value is bound to a name, you can’t change that value.
You can make them mutable by adding mut in front of the variable name.

It is however important to clarify the fact that even though the variable can be made mutable, Cairo works with an immutable memory model, meaning that changing the value of a variable will not change the value in memory but rather assign a new memory location to that variable.

## Further information

- [Memory model (from Cairo 0)](https://www.cairo-lang.org/docs/how_cairo_works/cairo_intro.html#memory-model)
- [Variables](https://cairo-book.github.io/ch02-01-variables-and-mutability.html)
- [Integer types](https://cairo-book.github.io/ch02-02-data-types.html#integer-types)

# Primitive Types

Cairo has a couple of basic types that are directly implemented into the
compiler. In this section, we'll go through the most important ones.

[Data Types](https://cairo-book.github.io/ch02-02-data-types.html)
