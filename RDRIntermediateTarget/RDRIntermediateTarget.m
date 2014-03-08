//
//  RDRIntermediateTarget.m
//
//  Created by Damiaan Twelker on 20/01/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

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
    if (self = [super init])
    {
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
    // definition.
    
    SEL selector = [anInvocation selector];
    
    if (![self.target respondsToSelector:selector]) {
        [super forwardInvocation:anInvocation];
    }
    else {
        [anInvocation invokeWithTarget:self.target];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    else {
        if ([self.target respondsToSelector:aSelector]) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{    
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (!signature) {
        signature = [self.target methodSignatureForSelector:aSelector];
    }
    
    return signature;
}

@end
