# Calculator-by-LemurWare
## A Programmer's Guide

This is a very simple calculator for the Apple Watch.

The app's website is [LemurWare.tech/calculator](https://lemurware.tech/calculator).

The app has simple functions like addition and division, but also more complex functions like sin, tan, and tip.

##### This calculator predates Apple's Apple Watch calculator by all of several months!

## Program Structure

#### Prerequisites
The overall structure of the program is very simple. This guide is intended for readers who know almost nothing about developing for the Apple Watch.
It is assumed that the reader knows basics about the Watch like what the [crown](https://developer.apple.com/design/human-interface-guidelines/watchos/user-interaction/digital-crown/) is, and that the watch pairs with an iPhone.
It is also assumed that teh reader knows the basics of at least one programming language.
It would help is this language were [Swift](https://www.apple.com/swift/), but almost any language would do.
E.g. Javascript, C#, C, and Java are all fine.

#### Swift basics for knowledgeable programmers.
Siwft is Apple's languge for iOS, Mac, Apple TV, and Apple Watch. 
```Swift
let myConstantPi = 3.14
var myChangingCounter = 0
```
Semicolons are optional, and can but used very much as is C# or JavaScript.
But don't use them, [they are dead to us](https://engineering.vokal.io/iOS/CodingStandards/Swift.md.html#semicolons).
