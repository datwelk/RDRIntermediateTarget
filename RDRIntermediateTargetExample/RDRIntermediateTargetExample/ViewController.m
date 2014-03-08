//
//  ViewController.m
//  RDRIntermediateTargetExample
//
//  Created by Damiaan Twelker on 07/03/14.
//  Copyright (c) 2014 Damiaan Twelker. All rights reserved.
//

#import "ViewController.h"
#import "RDRIntermediateTarget.h"
#import "AppDelegate.h"

static BOOL kRDRPatchEnabled = YES;

@interface ViewController ()

// Technically, the UI elements can be referred
// to weakly as well since they are retained by
// their superview. But I prefer this more explicit way of
// memory management because a UI element might be
// removed from its superview anytime temporarily.

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UISwitch *patchSwitch;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSUInteger count;

@end

@implementation ViewController

#pragma mark - Object lifecycle

- (void)dealloc
{
    NSLog(@"DEALLOC");
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    [self _setupSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _updateLabelText];
    [self _setupTimer];
}

#pragma mark - Private

- (void)_setupSubviews
{
    self.label = [UILabel new];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.font = [UIFont systemFontOfSize:40.0f];
    self.label.textColor = [UIColor blackColor];
    [self.view addSubview:self.label];
    
    self.patchSwitch = [UISwitch new];
    self.patchSwitch.on = kRDRPatchEnabled;
    [self.patchSwitch addTarget:self
                         action:@selector(_switchToggled:)
               forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.patchSwitch];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setTitle:NSLocalizedString(@"Dealloc", nil)
                 forState:UIControlStateNormal];
    [self.button addTarget:self
                    action:@selector(_buttonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    [self _setupConstraints];
}

- (void)_setupConstraints
{
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.patchSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraints = nil;
    NSString *visualFormat = nil;
    NSLayoutConstraint *constraint = nil;
    NSDictionary *views = @{@"label" : self.label,
                            @"switch" : self.patchSwitch,
                            @"button" : self.button};
    
    // Vertical constraints
    visualFormat = @"V:|-100-[label]";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self.view addConstraints:constraints];
    
    visualFormat = @"V:[switch]-10-[button]-20-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self.view addConstraints:constraints];
    
    // Horizontal constraints
    constraint = [NSLayoutConstraint constraintWithItem:self.label
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0f
                                               constant:0.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.patchSwitch
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0f
                                               constant:0.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.button
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0f
                                               constant:0.0f];
    [self.view addConstraint:constraint];
}

#pragma mark - Timer

- (void)_setupTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    id target = nil;
    SEL selector = @selector(_timerFired:);
    
    if (kRDRPatchEnabled) {
        target =
        [RDRIntermediateTarget intermediateTargetWithTarget:self];
    }
    else {
        target = self;
    }
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f
                                             target:target
                                           selector:selector
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer
                                 forMode:NSDefaultRunLoopMode];
    self.timer = timer;
}

- (void)_timerFired:(NSTimer *)timer
{
    self.count++;
    [self _updateLabelText];
}

#pragma mark - Label

- (void)_updateLabelText
{
    unsigned long long count = (unsigned long long)self.count;
    self.label.text = [NSString stringWithFormat:@"%llu", count];
}

#pragma mark - Switch

- (void)_switchToggled:(UISwitch *)aSwitch
{
    kRDRPatchEnabled = aSwitch.on;
    [self _setupTimer];
}

#pragma mark - Button

- (void)_buttonClicked:(UIButton *)button
{
    UIApplication *application = [UIApplication sharedApplication];
    AppDelegate *appDelegate = (AppDelegate *)[application delegate];
    [appDelegate resetRootViewController];
}

@end
