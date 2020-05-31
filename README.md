# Calculator by LemurWare
## A Programmer's Guide
This is a very simple calculator for the Apple Watch.

The app's website is [LemurWare.tech/calculator](https://lemurware.tech/calculator).

The app has simple functions like addition and division, but also more complex functions like sin, tan, and tip.

##### This calculator predates Apple's Apple Watch calculator by all of several months!

## Program Structure

#### Prerequisites
The overall structure of the program is very simple. This guide is intended for readers who know almost nothing about developing for the Apple Watch.
It is assumed that the reader knows basics about the Watch like what the [crown](https://developer.apple.com/design/human-interface-guidelines/watchos/user-interaction/digital-crown/) is, and that the Watch pairs with an iPhone.
It is also assumed that the reader knows the basics of at least one programming language.
It would help is this language were [Swift](https://www.apple.com/swift/), but almost any language would do.
E.g. Javascript, C#, C, and Java are all fine.
This guide also assumes the reader is familiar with Xcode.
Deep familiarity is not needed, but the guide will not cover installing or maintaining Xcode.

#### Swift basics for somewhat-knowledgeable programmers.
Siwft is Apple's languge for iOS, Mac, Apple TV, and Apple Watch.

Swift defines constants with `let` and variables with `var`.
Also, Swift is a typed language, but uses duck-typing at compile time to verify that the type is obvious from context.
If the compiler can't figure out the type from context, or if you want to specify the type for clarity, you can.
```Swift
let myConstantPi = 3.14
var myChangingCounter: Int = 0
```
This is simple, but flexible.
E.g. when deciding whether to take an umbrella, we need to check several states in a convoluted way.
Maybe the sky can be cloudy while being rainy or clear.
No matter how covoluted your if-statements, compile-time checking will verify that you have initialized your constant once and exactly once before it is used.
```Swift
let takeUmbrella: Bool
if(theSky.isCloudy()){
    if(walk.isLong){
        takeUmbrella = true
    }else{
        takeUmbrella = false
    }
}else if(theSky.isClear()){
    takeUmbrella = false
}else{
// theSky.isRaining()
    takeUmbrella = true
}
```
Semicolons are optional, and can but used very much as is C# or JavaScript.
But don't use them, [they are dead to us](https://engineering.vokal.io/iOS/CodingStandards/Swift.md.html#semicolons).

#### High-Level Structure
- `Calculator by LemurWare` is the iOS version of the app. This is no loger needed for new apps, but existing apps cannot "downgrade" to be an iOS-less app if they were originally published with and iOS companion app.
- `Calculator by LemurWare WatchKit App` is basically the GUI of the WatchOS app.
- `Calculator by LemurWare WatchKit Extension` is the code for the WatchOS app.

> Pro tip:
> 
> Notice how there's a `.xcassets` folder in ever top-lever folder?
> Different images go in different folders depending on where they are referenced.
> iOS goes in the iOS folder. Anything referenced by the watchOS GUI directly goes in the `WatchKit App` folder but anything referenced by watchOS code goes in the `WatchKit App Extension` folder.

###### InitializerInterfaceController
This is the "entry point" of the calculator.
In `WatchKit App`'s `Interface.storyboard` a loading screen is defined as the initial screen.
Its backend code is `InitializerInterfaceController`.
`InitializerInterfaceController`'s `awake` function does only one thing, reload the screen with the proper 3 screens, starting with the middle screen.

###### NumberInputInterfaceController
This is the initial screen the user sees.
It features all 10 digit, a display for the number, a clear/total button, and a decimal button.

On the backend, there are 2 hooks for the UI (`valueDisplay`, `acButtonLabel`), 2 variables storing info about the decimal places entered, and a `state` variable.

###### TrigFunctionsInterfaceController
