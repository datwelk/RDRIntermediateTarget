//
//  RDRIntermediateTarget.m
//
//  Created by Damiaan Twelker on 20/01/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//
//  LICENSE
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Damiaan Twelker
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "RDRIntermediateTarget.h"

@interface RDRIntermediateTarget ()

@property (nonatomic, weak) id target;

@end

@implementation RDRIntermediateTarget

#pragma mark - Class methods

+ (instancetype)intermediateTargetWithTarget:(id)target
{
    return [[[self class] alloc] initWithTarget:target];
}

#pragma mark - Lifecycle

- (id)initWithTarget:(id)target
{
    if (self = [super init]) {
        _target = target;
    }
    
    return self;
}

#pragma mark - Method forwarding

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // No need to check which selector is called, because
    // the "source" (NSTimer, CADisplayLink or NSThread)
    // will only call one method on this instance by
    // definition (the one passed to the initializer of
    // respective classes).
    
    SEL selector = [anInvocation selector];
    
    // Target may be deallocated if self is strongly held.
    // Silence messages sent to self in that case. Otherwise
    // an unrecognized selector exception is triggered.
    // https://stackoverflow.com/a/11531609/1127387
    // First check if target is alive & responds. If not alive,
    // silence the invocation. If alive and no response,
    // forward to super.
    
    if (self.target && [self.target respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:self.target];
    } else if (!self.target) {
        id nilPtr = nil;
        [anInvocation setReturnValue:&nilPtr];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [self methodSignatureForSelector:aSelector] != nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    // Target may be deallocated if self is strongly held.
    // Silence messages sent to self in that case. Otherwise
    // an unrecognized selector exception is triggered.
    // https://stackoverflow.com/a/11531609/1127387
    if (self.target && [self.target respondsToSelector:aSelector]) {
        return [self.target methodSignatureForSelector:aSelector];
    } else if (!self.target) {
        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

@end
