yavfl
=====

Yet Anoter Visual Format Language for Auto Layout.

## Differences from the Original Visual Format Language

The syntax is changed due to Swift's syntax limitation.

* Do not use `()` for view's *predicate*.
    * Use `[button1,==button2]` instead of `[button1(==button2)]`.
* Use `~` instead of `:` for *orientation* and `@` for *priority*, which can not be used for custom operators.
    * Use `.H ~ |-[view]-|` instead of `H:|-[view]-|`.
    * Use `[view,==100~200]` instead of `[view(==100@200)]`.
* *Orientation* (`.H` or `.V`) and operator `~` are required for applying layout constraints.
    * Operator `~` is a trigger for creating and applying constraints.
* *Connection* (`-`) is required between views.
    * `[v1][v2]` is not allowed due to the syntax limitation. Use `[v1]-0-[v2]` instead.
* *Relation* (`==`, `<=` or `>=`) is required for *predicate*.
    * `[view,100]` is not allowed. Use `[view,==100]` instead.
* *Connection*'s *predicateList* is not supported.


## Install

Just copy `yavfl.swift` into your project.
