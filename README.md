RDRIntermediateTarget
=====================

A project that demonstrates the use of Objective-C's message passing capabilities to prevent retain cycles caused by NSTimer, NSThread or CADisplayLink instances.

# Introduction
As you may already know, `NSTimer`, `NSThread`, and `CADisplayLink` instances retain their targets. If the target retains an instance of one of these classes as well, we have a retain cycle: neither the target nor the instance will ever be deallocated.

Why would you want to retain an instance of one of these classes? Imagine you have a certain view animation that requires the use of a `CADisplayLink` instance. As soon as the animation has finished, the `CADisplayLink` instance is not needed anymore and should be paused to prevent your app from waisting resources. In order to pause it, you will have to keep a reference to it.

At this point you might wonder: why not keep a weak reference to the instance instead of a strong one? Doesn't this solve all our problems? The answer is no, because it doesn't change the fact that the target is retained. For example, a `UIViewController` instance that has a weak reference to a repeating `NSTimer` object will never be deallocated because it is retained by the timer.

# What does it do
It enables you to create `NSTimer`s, `NSThread`s and `CADisplayLink`s without having to worry about retain cycles.

# How does it work


# How to use


# License
The code is licensed under the MIT license. See `LICENSE` for more details.
