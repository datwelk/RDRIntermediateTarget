//
//  AppDelegate.m
//  RDRIntermediateTargetExample
//
//  Created by Damiaan Twelker on 07/03/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate () {
    ViewController *_rootViewController;
}

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _rootViewController = [ViewController new];
    self.window.rootViewController = _rootViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
