RDRIntermediateTarget
=====================

A project that demonstrates the use of Objective-C's message passing capabilities to prevent retain cycles.

# Introduction
As you may already know, `NSTimer`, `NSThread`, and `CADisplayLink` retain their targets. If the target retains an instance of one of these classes as well, we have a retain cycle: neither the target nor the instance will ever be deallocated. 

For example, let's take a look at `CADisplayLink`. A certain view animation inside a `UIViewController` instance of your app might require the use of a `CADisplayLink` instance. As soon as the animation has finished, the `CADisplayLink` is not needed anymore and should be paused to prevent your app from waisting resources. In order to pause a `CADisplayLink` instance, you will have to keep a reference to it. 

# Disclaimer
There is a reason Apple designed the aforementioned classes to retain their target. You have been warned. (However, with ARC introducing weak references, I personally do not see much danger in the "trick" demonstrated in this repo. Please correct me if I am wrong.)

# License
The code is licensed under the MIT license. See `LICENSE` for more details.
