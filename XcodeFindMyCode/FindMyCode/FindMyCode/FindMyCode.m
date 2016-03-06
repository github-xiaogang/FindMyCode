//
//  FindMyCode.m
//  XcodeFindMyCode
//
//  Created by 张小刚 on 16/3/6.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "FindMyCode.h"
@import UIKit;

@interface FMCLongPressGestureRecognizer : UILongPressGestureRecognizer

@end

@interface UIWindow (FindMyCode)

- (void)fmc_setupTrigger;

@end

@interface FindMyCode ()

@property (nonatomic, strong) NSString * controllerClassName;

@end

@implementation FindMyCode

+ (void)load
{
    [[FindMyCode sharedInstance] setup];
}

+ (FindMyCode *)sharedInstance
{
    static FindMyCode * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FindMyCode alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.triggerMode = FMCTriggerModeTwoFingerLongPress;
    }
    return self;
}

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appKeyWindowChanged:) name:UIWindowDidBecomeKeyNotification object:nil];
}

- (void)appKeyWindowChanged:(NSNotification *)notification
{
    UIWindow * keyWinow = (UIWindow *)notification.object;
    [keyWinow fmc_setupTrigger];
}

- (void)setTriggerMode:(FMCTriggerMode)triggerMode
{
    _triggerMode = triggerMode;
    UIWindow * keyWinow = [UIApplication sharedApplication].keyWindow;
    if(keyWinow){
        [keyWinow fmc_setupTrigger];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation FMCLongPressGestureRecognizer

@end

@implementation UIWindow (FindMyCode)

- (void)fmc_setupTrigger
{
#if DEBUG
    FMCLongPressGestureRecognizer * targetRecognizer = nil;
    for (UIGestureRecognizer * recognizer in self.gestureRecognizers) {
        if([recognizer isKindOfClass:[FMCLongPressGestureRecognizer class]]){
            targetRecognizer = (FMCLongPressGestureRecognizer *)recognizer;
            break;
        }
    }
    if(!targetRecognizer){
        targetRecognizer = [[FMCLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(fmc_triggerGestureRecognized:)];
        [self addGestureRecognizer:targetRecognizer];
    }
    targetRecognizer.numberOfTouchesRequired = [[FindMyCode sharedInstance] triggerMode];
#endif
}

- (void)fmc_triggerGestureRecognized:(UILongPressGestureRecognizer *)recognizer
{
    if(recognizer.state != UIGestureRecognizerStateBegan){
        return;
    }
    CGPoint point = [recognizer locationInView:self];
    UIView * targetView = [self hitTest:point withEvent:nil];
    UIViewController * targetVC = [self fmc_getViewController:targetView];
    if(!targetVC) return;
    NSString * controllerClasName = NSStringFromClass(targetVC.class);
    [FindMyCode sharedInstance].controllerClassName = controllerClasName;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Find My Code" message:[NSString stringWithFormat:@"Xcode Open %@.m ?",controllerClasName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != 1){
        return;
    }
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSString * requestCmd = [NSString stringWithFormat:@"XcodeFindMyCode[%.f] request open file %@.m",now,[FindMyCode sharedInstance].controllerClassName];
    NSString * seperator = @"--------------------------XcodeFindMyCode----------------------";
    NSLog(@"\n\n\n%@\n\n%@\n\n%@\n\n\n",seperator,requestCmd,seperator);
}

- (UIViewController *)fmc_getViewController: (UIView *)view
{
    UIViewController * result = nil;
    UIResponder * nextResponder = view;
    while ((nextResponder = nextResponder.nextResponder)) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            result = (UIViewController *)nextResponder;
            break;
        }
    }
    return result;
}


@end









