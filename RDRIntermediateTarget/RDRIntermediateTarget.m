//
//  RDRIntermediateTarget.m
//
//  Created by Damiaan Twelker on 20/01/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "RDRIntermediateTarget.h"
#import <objc/runtime.h>

@interface RDRIntermediateTarget ()

@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;

@end

@implementation RDRIntermediateTarget

#pragma mark - Class methods

+ (instancetype)intermediateTargetWithTarget:(id)target
                                    selector:(SEL)selector
{
    return [[[self class] alloc] initWithTarget:target
                                       selector:selector];
}

#pragma mark - Lifecycle

- (id)initWithTarget:(id)target
            selector:(SEL)selector
{
    if (self = [super init])
    {
        // The given selector is a selector implemented
        // by the given target. The selector will however be
        // called on this instance since it acts as an
        // intermediate target. Therefore we implement
        // the appropriate methods to forward an invocation
        // with the given selector to the given target.
        
        _target = target;
        _selector = selector;
    }
    
    return self;
}

#pragma mark - Method forwarding

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = [anInvocation selector];
    
    if ([self.target respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:self.target];
    }
    else {
        [super forwardInvocation:anInvocation];
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
    }
    
    return NO;
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
