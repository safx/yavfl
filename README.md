#yavfl

[![TravisCI](http://img.shields.io/travis/safx/yavfl.svg?style=flat)](https://travis-ci.org/safx/yavfl)
![Platform](https://img.shields.io/cocoapods/p/yavfl.svg?style=flat)
![License](https://img.shields.io/cocoapods/l/yavfl.svg?style=flat)
![Version](https://img.shields.io/cocoapods/v/yavfl.svg?style=flat)
![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)

yavfl is Yet Anoter Visual Format Language for Auto Layout.


## Usage

In yavfl, you can write the code of visual format language as follows:

```swift
visualFormat(label, textField) { l, t in
    .V ~ |-40-[l,==32]
    .V ~ |-40-[t,==32]
    .H ~ |-20-[l,==t]-10-[t]-|
}
```

![](./images/layout_sample.png)

The equivallent code of the original visual format is follows:

```swift
let dic = ["l": label, "t": textField]
label.setTranslatesAutoresizingMaskIntoConstraints(false)
textField.setTranslatesAutoresizingMaskIntoConstraints(false)
let c1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[l(32)]", options: nil, metrics: nil, views: dic)
let c2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[t(32)]", options: nil, metrics: nil, views: dic)
let c3 = NSLayoutConstraint.constraintsWithVisualFormat("|-20-[l(==t)]-10-[t]-|", options: nil, metrics: nil, views: dic)
self.view.addConstraints(c1)
self.view.addConstraints(c2)
self.view.addConstraints(c3)
```

## More Examples

| yavfl                                         | origial                                   |
|-----------------------------------------------|-------------------------------------------|
| `.H ~ [button]-[textField]`                   | `[button]-[textField]`                    |
| `.H ~ [button,>=50]`                          | `[button(>=50)]`                          |
| `.H ~ |-50-[purpleBox]-50-|`                  | `|-50-[purpleBox]-50-|`                   |
| `.V ~ [topField]-10-[bottomField]`            | `V:[topField]-10-[bottomField]`           |
| `.H ~ [maroonView]-0-[blueView]`              | `[maroonView][blueView]`                  |
| `.H ~ [button,==100~20]`                      | `[button(100@20)]`                        |
| `.H ~ [button1,==button2]`                    | `[button1(==button2)]`                    |
| `.H ~ [flexibleButton,>=70,<=100]`            | `[flexibleButton(>=70,<=100)]`            |
| `.H ~ |-[find]-[findNext]-[findField,>=20]-|` | `|-[find]-[findNext]-[findField(>=20)]-|` |


## Limitations

* Yavfl does not check syntatic validity. You don't expect the code is valid even if its compilation succeeded.
* *Connection*'s *predicateList* supports only one *predicate*.
* `visualFormat` supports up to 5 views.

## Differences from the Original Visual Format Language

Some parts of the syntax are changed due to Swift's syntax limitation.

* Do not use `()` for view's *predicate*.
    * Use `[button1,==button2]` instead of `[button1(==button2)]`.
* Use `~` instead of `:` for *orientation* and `@` for *priority*, because these can not be used for custom operators.
    * Use `.H ~ |-[view]-|` instead of `H:|-[view]-|`.
    * Use `[view,==100~200]` instead of `[view(==100@200)]`.
* *Orientation* (`.H` or `.V`) and operator `~` are required for applying layout constraints.
    * Operator `~` is a trigger for creating and applying constraints.
* *Connection* (`-`) is required between views.
    * `[v1][v2]` is not allowed due to the syntax limitation. Use `[v1]-0-[v2]` instead.
* *Relation* (`==`, `<=` or `>=`) is required for *predicate*.
    * `[view,100]` is not allowed. Use `[view,==100]` instead.


## Install

    pod 'yavfl'

Or, just copy `yavfl.swift` into your project.
