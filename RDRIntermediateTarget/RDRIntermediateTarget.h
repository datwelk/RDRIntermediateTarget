//
//  RDRIntermediateTarget.h
//
//  Created by Damiaan Twelker on 20/01/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDRIntermediateTarget : NSObject

+ (instancetype)intermediateTargetWithTarget:(id)target;
- (instancetype)initWithTarget:(id)target;

@end
