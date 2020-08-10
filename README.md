# ComposableTuistArchitecture

[Swift Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) is a great library providing
users with a new way how they can build iOS apps, especially shining in the SwiftUI realm.

The architecture, being called composable after all, can be highly modularized where each view can be its own separate module.
While this brings a lot of benefits (such as build times or better separation of concerns), unfortunately,
it has also a lot of maintenance attached to it. You need to have strong knowledge of how Xcode modules work
and that may get daunting for new co-workers who'll get introduced to your codebase.

That's why we think that [tuist](https://github.com/tuist/tuist) is a great fit since you can codify
how one can add a new module and one does not have to know all the quirks of Xcode.

With tuist creating a new module can be as easy as running `tuist scaffold feature --name MyNewFeature` - which is something you can
try it in the example app in this repository.

The example app is a simple SwiftUI cookbook app, feel free to poke around it and let me know
if you have any questions about how to combine tuist and Swift Composable Architecture,
I'd happy to chat about it 🙂

(you can find me [@marekfort](https://twitter.com/marekfort) or via email which I have stated in my Github profile)