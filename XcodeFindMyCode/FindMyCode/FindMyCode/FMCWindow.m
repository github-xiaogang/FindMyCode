//
//  FMCWindow.m
//  FindMyCode
//
//  Created by 张小刚 on 16/3/1.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "FMCWindow.h"

@interface FMCWindow ()<UIAlertViewDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer * triggerRecognizer;
@property (nonatomic, strong) NSString * controllerClassName;

@end

@implementation FMCWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self fmc_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self fmc_commonInit];
    }
    return self;
}

- (void)fmc_commonInit
{
    UILongPressGestureRecognizer * recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(fmc_TriggerGestureRecognized:)];
    self.triggerRecognizer = recognizer;
    self.triggerRecognizer.numberOfTouchesRequired = FMCTriggerModeTwoFingerLongPress;
    [self addGestureRecognizer:self.triggerRecognizer];
}

- (void)setTriggerMode: (FMCTriggerMode) triggerMode{
    self.triggerRecognizer.numberOfTouchesRequired = triggerMode;
}

- (void)fmc_TriggerGestureRecognized:(UILongPressGestureRecognizer *)recognizer
{
    if(recognizer.state != UIGestureRecognizerStateBegan){
        return;
    }
    CGPoint point = [recognizer locationInView:self];
    UIView * targetView = [self hitTest:point withEvent:nil];
    UIViewController * targetVC = [self fmc_getViewController:targetView];
    if(!targetVC) return;
    NSString * controllerClasName = NSStringFromClass(targetVC.class);
    self.controllerClassName = controllerClasName;
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Find My Code" message:[NSString stringWithFormat:@"Open %@.m",controllerClasName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != 1){
        return;
    }
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSString * requestCmd = [NSString stringWithFormat:@"XcodeFindMyCode[%.f] request open file %@.m",now,self.controllerClassName];
    NSString * seperator = @"--------------------------XcodeFindMyCode----------------------";
    NSLog(@"\n\n\n%@\n\n%@\n\n%@\n\n\n",seperator,requestCmd,seperator);
}

- (UIViewController *)fmc_getViewController: (UIView *)view
{
    UIResponder * nextResponder = view;
    while ((nextResponder = nextResponder.nextResponder)) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return (UIViewController *)nextResponder;
}

@end










